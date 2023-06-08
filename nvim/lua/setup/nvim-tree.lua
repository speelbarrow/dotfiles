return {
    setup = function()
        local nvim_tree = require'nvim-tree'
        local nvim_tree_api = require'nvim-tree.api'

        local M = {}

        -- Configure custom icons for nvim-web-devicons		
        require'nvim-web-devicons'.setup {
            override = {
                go = {
                    icon = '󰟓',
                    color = "#519aba",
                    cterm_color = "74",
                    name = "Go",
                },
                ["gohtml"] = {
                    icon = '󰟓',
                    color = "#519aba",
                    cterm_color = "74",
                    name = "GoHTML",
                },
                ["go.mod"] = {
                    icon = '󰟓',
                    color = "#519aba",
                    cterm_color = "74",
                    name = "GoModules",
                },
            }
        }

        -- Set up the plugin
        nvim_tree.setup {
            on_attach = function(bufnr)
                -- Open on enter
                for key, modes in pairs({ ['<CR>'] = { 'n' }, ['<2-LeftMouse>'] = { 'n', 'i' }}) do
                    vim.keymap.set(modes, key, nvim_tree_api.node.open.edit, { buffer = bufnr })
                end

                -- Shift-enter to replace buffer in previously selected window
                vim.keymap.set('n', "<S-CR>", function()
                    -- Save the cursor position within the tree so we can open the
                    -- correct file later ...
                    local save_cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())

                    -- ... switch back to the previous window (where a file was
                    -- being edited) and determine what the buffer number is ...
                    vim.cmd.wincmd "p"
                    local to_close = vim.api.nvim_get_current_buf()
                    if vim.fn.getbufinfo({ bufnr = to_close })[1].changed == 1 then
                        vim.notify("Buffer is modified, can't replace", vim.log.levels.ERROR)
                        return
                    end

                    -- ... switch back to the tree and open the selected file based
                    -- on the cursor position from before ...
                    vim.cmd.wincmd "p"
                    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), save_cursor)
                    nvim_tree_api.node.open.edit()

                    -- ... close the previous buffer
                    vim.api.nvim_buf_delete(to_close, {})
                end, { buffer = bufnr })

                -- 'Un'-focus the tree without closing on tab
                vim.keymap.set('n', '<Tab>', function()
                    if #(vim.api.nvim_list_wins()) > 1 then
                        vim.cmd.wincmd 'p'
                    else
                        vim.cmd.bn()
                    end
                end, { buffer = bufnr, silent = true })

                -- Expand all nodes on 'E'
                vim.keymap.set('n', 'E', nvim_tree_api.tree.expand_all, { buffer = bufnr })

                -- Collapse all nodes on 'C'
                vim.keymap.set('n', 'C', nvim_tree_api.tree.collapse_all, { buffer = bufnr })

                -- Helper function to create an anonymous function that executes a 
                -- Git command on the current node
                -- (uses the `Git` command from the fugitive plugin)
                ---@param args string
                local function git(args)
                    return function()
                        vim.cmd('Git ' .. args .. ' ' ..
                        vim.fn.fnamemodify(nvim_tree_api.tree.get_node_under_cursor().absolute_path, ':.'))
                    end
                end

                -- Set keymaps using `git` function
                for key, command in pairs(
                    {
                        ['s'] = 'restore --staged',
                        ['d'] = 'rm --cached',
                        ['DD'] = 'checkout HEAD --',
                    }) do
                    vim.keymap.set('n', key, git(command), { buffer = bufnr })
                end
                -- Set `git add` seperately for overriding when root node is selected
                vim.keymap.set('n', 'a', function()
                    if nvim_tree_api.tree.get_node_under_cursor().name == ".." then
                        vim.cmd "Git add ."
                    else
                        git('add')()
                    end
                end, { buffer = bufnr })

                -- Set 'git commit' and 'git push' keymaps seperately due to different format
                vim.keymap.set('n', '<C-a>', "<Cmd>tab Git commit<CR>", { buffer = bufnr })
                vim.keymap.set('n', '<C-s>', "<Cmd>Git push<CR>", { buffer = bufnr })
                vim.keymap.set('n', '<C-x>', function()
                    vim.cmd "tab Git commit"
                    vim.api.nvim_create_autocmd("User", {
                        pattern = "FugitiveChanged",
                        once = true,
                        command = "Git push"
                    })
                end, { buffer = bufnr })

                -- Arrow key mappings
                for key, command in pairs {
                    ["S-Up"] = nvim_tree_api.node.navigate.sibling.prev,
                    ["S-Down"] = nvim_tree_api.node.navigate.sibling.next,
                    Left = nvim_tree_api.node.navigate.parent,
                    Right = function()
                        local node = nvim_tree_api.tree.get_node_under_cursor()
                        if node.fs_stat and node.fs_stat.type == "directory" then
                            nvim_tree_api.node.open.edit()
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, false, true), "n",
                            false)
                        end
                    end,
                }
                do
                    vim.keymap.set('n', "<" .. key .. ">", command, { buffer = bufnr })
                end
            end,
            disable_netrw = true,
            hijack_cursor = true,
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true,
                ignore_list = {"help", "gitcommit"}
            },
            filters = { custom = { "^\\.git$", "^go\\.sum$" } },
            git = { enable = true },
            renderer = {
                highlight_git = true,
                highlight_opened_files = "name",
                root_folder_label = ':~:s?$?/...?',
                icons = {
                    glyphs = {
                        git = {
                            unstaged = '!=',
                            staged = '+',
                            untracked = '?',
                            deleted = '-',
                        }
                    }
                }
            }
        }

        -- Set up keybind for toggling tree view
        vim.keymap.set('n', '<Tab>', nvim_tree_api.tree.focus)
        vim.keymap.set('n', '<S-Tab>', function()
            nvim_tree_api.tree.toggle({ find_file = true, focus = false })
        end)

        -- Define user command for opening a new buffer relative to tree cursor
        vim.api.nvim_create_user_command("E", function(args)
            local to_open = args.fargs[1]

            local node = nvim_tree_api.tree.get_node_under_cursor()
            while node.parent ~= nil do
                if node.fs_stat.type == 'directory' then
                    to_open = node.absolute_path .. '/' .. to_open
                    break
                else
                    node = node.parent
                end
            end

            vim.cmd.edit(to_open)
        end, { nargs = 1 })

        -- Define filetypes where the tree shouldn't automatically open
        M.no_auto_open_list = { 'help', 'gitcommit', 'gitrebase' }

        -- Transform the list into a map for faster lookup
        local no_auto_open = {}
        for _, filetype in ipairs(M.no_auto_open_list) do
            no_auto_open[filetype] = true
        end

        -- Helper function for code reusability
        ---@param filetype string
        local function open_tree(filetype)
            -- Check if the tree is already open ...
            if nvim_tree_api.tree.is_visible() then return end

            -- ... check if the filetype is in the no_auto_open list ...
            if no_auto_open[filetype] then return end

            -- ... check if there is a project root ...
            local project_root = require'project_nvim.project'.get_project_root()

            -- ... check if the working directory has already changed ...
            if vim.fn.getcwd() == project_root then
                nvim_tree_api.tree.toggle({ find_file = true, focus = false })
            else
                -- ... if not, set up an autocmd to open the tree when the
                --     working directory changes
                vim.api.nvim_create_autocmd("DirChanged", {
                    once = true,
                    callback = function() nvim_tree_api.tree.toggle({ find_file = true, focus = false }) end
                })
            end
        end

        -- Call once now, once the filetype is determined (because by the time the autocmd is set up the first 
        -- TabNewEntered event has already fired) ...
        vim.api.nvim_create_autocmd("BufEnter", {
            once = true,
            callback = function(args)
                open_tree(vim.api.nvim_buf_get_option(args.buf, "filetype"))
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w><C-w>", true, true, true), "n", true)
            end
        })

        -- ... and set up an autocmd to run it when a new tab is entered
        vim.api.nvim_create_autocmd("TabNewEntered", {
            callback = function(args)
                open_tree(vim.api.nvim_buf_get_option(args.buf, "filetype"))
            end
        })

        return M
    end
}

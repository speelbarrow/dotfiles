return {
    setup = function()
        local startup = require'startup'

        vim.api.nvim_create_autocmd("UIEnter", {
            once = true,
            callback = function(args)
                if args.file == "" and not require'neo-tree.ui.renderer'.tree_is_visible(
                    require'neo-tree.sources.manager'.get_state("filesystem")
                ) then
                    startup.display()
                end
            end
        })

        local projects = require'project_nvim'.get_recent_projects()
        startup.setup {
            header = (function()
                local r = require'startup.themes.startify'.header
                r.align = "center"

                -- Center-able cow
                local cow = {
                    " \\   ^__^                 ",
                    " \\  (oo)\\_______        ",
                         "(__)\\       )\\/\\",
                             "||----w |",
                             "||     ||",
                }

                -- Replace the cow
                for index, line in ipairs(cow) do
                    r.content[#r.content-#cow+index] = line
                end

                -- Add a blank line
                table.insert(r.content, "")

                -- Determine the version
                local version = vim.api.nvim_exec2("version", { output = true }).output

                -- Add a line with the version to the header
                table.insert(r.content, "NeoVim "..version:sub(version:find("v[0-9]%.[0-9]%.[0-9]")))

                -- Return the modified header
                return r
            end)(),
            last_project = {
                type = "mapping",
                align = "center",
                highlight = "DraculaPurpleBold",
                content = {
                    {
                        "Reopen Last File ("..vim.fn.fnamemodify(vim.v.oldfiles[1], ":t")..")",
                        "e "..vim.v.oldfiles[1].." | e",
                        "ff"
                    },
                    {
                        "Reopen Last Project ("..vim.fn.fnamemodify(projects[#projects], ":t")..")",
                        "cd "..projects[#projects].." | wincmd w",
                        "pp"
                    }
                }
            },
            mapping_area = {
                type = "mapping",
                align = "center",
                highlight = "DraculaPink",
                content = {
                    { "New file", "enew", "N" },
                    { "Recent Files...", "Telescope oldfiles", "F" },
                    { "Recent Projects...", "Telescope projects", "P" },
                }
            },
            parts = { "header", "last_project", "mapping_area" },
            options = {
                paddings = {3, 5, 1},
                after = function()
                    vim.o.colorcolumn = "0"
                    vim.api.nvim_create_autocmd("BufLeave", {
                        buffer = 0,
                        callback = function()
                            vim.o.colorcolumn = "+1"
                            vim.cmd "bd"
                        end
                    })
                    vim.keymap.set('n', '<S-Tab>', '<Cmd>enew<CR><Cmd>Neotree<CR>', { buffer = true })
                end
            }
        }
    end
}

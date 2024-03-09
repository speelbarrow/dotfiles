local M = {}

function M.setup()
    local startup = require'startup'

    vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function(args)
            if args.file == "" and not require'neo-tree.ui.renderer'.tree_is_visible(
                require'neo-tree.sources.manager'.get_state("filesystem")
            ) then
                vim.schedule(startup.display)
            end
        end
    })

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
            table.insert(r.content, "NeoVim "..version:sub(version:find("v[0-9]%.[0-9]+%.[0-9]")))

            -- Return the modified header
            return r
        end)(),
        last_project = {
            type = "mapping",
            align = "center",
            highlight = "DraculaPurpleBold",
            content = {
                M.last_file(),
                M.last_project(),
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

---@return string[]?
function M.last_file()
    for _, filename in ipairs(vim.v.oldfiles) do

        if filename:find("neo%-tree filesystem %[[0-9]+%]$") == nil then
            return {
                "Reopen Last File ("..vim.fn.fnamemodify(filename, ":t")..")",
                "e "..filename.." | e",
                "ff"
            }
        end
    end
end

function M.last_project()
    local projects = require'project_nvim'.get_recent_projects()
    if #projects > 0 then
        return {
            "Reopen Last Project ("..vim.fn.fnamemodify(projects[#projects], ":t")..")",
            "e "..projects[#projects].." | e",
            "pp"
        }
    end
end

return M

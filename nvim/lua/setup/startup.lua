return {
    setup = function()
        local startup = require'startup'

        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function(args)
                if args.file == "" and not require'nvim-tree.api'.tree.is_visible() then
                    startup.display()
                end
                return true
            end
        })

        local projects = require'project_nvim'.get_recent_projects()
        startup.setup {
            header = (function()
                local r = require'startup.themes.startify'.header
                r.align = "center"

                -- Center-able cow
                local cow = {
                    "\\   ^__^                 ",
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
                        "Reopen Last Project ("..vim.fn.fnamemodify(projects[#projects], ":t")..")",
                        "cd "..projects[#projects].." | wincmd w",
                        "pp"
                    }
                }
            },
            more_projects = {
                type = "mapping",
                align = "center",
                highlight = "DraculaPurpleBold",
                fold_section = true,
                title = "[Tab] More projects...",
                content = (function()
                    local r = {}
                    for i = 1, 9 do
                        if projects[#projects-i] then
                            table.insert(r, {
                                "Reopen "..projects[#projects-i],
                                "cd "..projects[#projects-i].." | wincmd w",
                                "p"..i
                            })
                        end
                    end

                    return r
                end)()
            },
            mapping_area = {
                type = "mapping",
                align = "center",
                highlight = "DraculaPink",
                content = {
                    { "Recent Projects...", "Telescope projects", "P" },
                    { "Recent Files...", "Telescope oldfiles", "F" },
                }
            },
            parts = { "header", "last_project", "more_projects", "mapping_area" },
            options = {
                paddings = {3, 5, 0, 2},
                after = function()
                    vim.o.colorcolumn = "0"
                    vim.api.nvim_create_autocmd("BufLeave", {
                        buffer = 0,
                        callback = function()
                            vim.o.colorcolumn = "+1"
                            vim.cmd "bd"
                        end
                    })
                end
            }
        }
    end
}

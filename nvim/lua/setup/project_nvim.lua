return {
    setup = function()
        require 'project_nvim'.setup {
            ignore_lsp = {
                'copilot',
                'lua_ls'
            }
        }

        -- Load telescope plugin, override default action
        local telescope = require'telescope'
        telescope.load_extension "projects"

        telescope.extensions.projects._projects = telescope.extensions.projects.projects
        telescope.extensions.projects.projects = function(_)
            telescope.extensions.projects._projects {
                attach_mappings = function(bufnr, _)
                    require'telescope.actions'.select_default:replace(function()
                        vim.fn.maparg("w", "n", nil, true).callback(bufnr) ---@diagnostic disable-line
                    end)
                    return true
                end
            }
        end
    end
}

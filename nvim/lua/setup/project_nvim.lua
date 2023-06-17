return {
    setup = function()
        require 'project_nvim'.setup {
            ignore_lsp = {
                'copilot',
                'lua_ls'
            }
        }

        -- Load telescope extension and override default behaviour

        local telescope = require 'telescope'
        telescope.load_extension "projects"

        telescope.extensions.projects._projects = telescope.extensions.projects.projects
        telescope.extensions.projects.projects = function(_)
            telescope.extensions.projects._projects {
                attach_mappings = function(prompt_bufnr, map)
                    local function close_and_switch()
                        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                            if bufnr ~= prompt_bufnr and vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "nofile" then
                                vim.api.nvim_buf_delete(bufnr, {})
                            end
                        end

                        ---@diagnostic disable-next-line
                        vim.fn.maparg('f', 'n', nil, true).callback()
                    end

                    map('n', '<S-CR>', close_and_switch)
                    map('i', '<S-CR>', close_and_switch)

                    return true
                end
            }
        end
    end
}

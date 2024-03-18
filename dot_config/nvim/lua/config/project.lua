local M = {}

function M.setup()
    require"project_nvim".setup {
        ignore_lsp = {
            'copilot',
            'lua_ls',
            'clangd',
            'taplo',
        }
    }
end

return M

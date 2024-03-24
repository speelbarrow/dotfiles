local M = {}

function M.setup()
    require"gitsigns".setup {
        on_attach = function(bufnr)
        end,
        _signs_staged_enable = true,
        numhl = true,
        preview_config = {
            border = "rounded",
        },
        yadm = {
            enable = true,
        },
    }
end

return M

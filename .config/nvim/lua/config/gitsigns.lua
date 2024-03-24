local M = {}

function M.setup()
    require"gitsigns".setup {
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

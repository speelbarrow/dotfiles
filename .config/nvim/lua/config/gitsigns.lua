local M = {}

function M.setup()
    require"gitsigns".setup {
        _signs_staged_enable = true,
        yadm = {
            enable = true,
        },
    }
end

return M

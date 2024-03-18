local M = {}

function M.setup()
    require"dashboard".setup {
        config = {
            week_header = {
                enable = true
            },
        },
    }
end

return M

local M = {}

function M.setup()
    vim.notify = require"notify"

    ---@diagnostic disable-next-line: missing-fields
    vim.notify.setup {
        background_colour = require"dracula".colors()["bg"]
    }

end

return M

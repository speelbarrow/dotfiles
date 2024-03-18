local M = {}

function M.setup()
    require"copilot".setup {
        suggestion = {
            auto_trigger = true,
            hide_during_completion = false,
            keymap = {
                accept = "<C-Enter>",
                next = "<C-x>",
                prev = "<C-z>",
                dismiss = "<C-e>",
            },
        },
    }
end

return M

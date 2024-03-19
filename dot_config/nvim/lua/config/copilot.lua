local M = {}

function M.setup()
    require"copilot".setup {
        suggestion = {
            auto_trigger = true,
            hide_during_completion = false,
            keymap = {
                accept = "<S-Enter>",
                next = "<S-Down>",
                prev = "<S-Up>",
                dismiss = "<S-BS>",
            },
        },
    }
end

return M

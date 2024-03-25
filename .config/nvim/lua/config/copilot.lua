local M = {}

function M.setup()
    require"copilot".setup {
        suggestion = {
            auto_trigger = true,
            hide_during_completion = false,
            keymap = {
                next = "<S-Down>",
                prev = "<S-Up>",
                accept = "<S-Enter>",

                -- See `after/plugin/keymap/lsp.lua`
                -- dismiss = "<S-BS>",
            },
        },
    }
end

-- Configure highlight groups
vim.cmd.highlight [[ CopilotSuggestion cterm=italic gui=italic guifg=#969696 ]]

return M

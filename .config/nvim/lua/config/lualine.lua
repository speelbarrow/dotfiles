local M = {}

function M.setup()
    -- Disable the default mode display
    vim.o.showmode = false

    require"lualine".setup {
        options = {
            theme = "dracula-nvim"
        },
        sections = {
            lualine_b = {
                {
                    "buffers",
                    show_filename_only = false,
                    symbols = {
                        alternate_file = "",
                        directory = "󰉖 ",
                    },
                }
            },
            lualine_c = {
                require"lsp-progress".progress,
            },
            lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_lsp" },
                    sections = { "error", "warn", "info", "hint" },
                    symbols = {
                        error = "󱎘 ",
                        warning = "󱈸 ",
                        info = " ",
                        hint = "󰙴 ",
                    }
                },
                "(vim.b.copilot_suggestion_auto_trigger == false) and '' or ''",
            },
            lualine_y = {
                "filetype",
                "o:shiftwidth",
                "fileformat",
                "encoding",
            },
            lualine_z = {
                "progress",
                "location",
                "branch",
                "diff",
            }
        },
    }

    -- listen lsp-progress event and refresh lualine
    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
    })
end

return M

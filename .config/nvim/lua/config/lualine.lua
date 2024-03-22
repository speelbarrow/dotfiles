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
                "branch",
                "diff"
            },
            lualine_c = {
                {
                    "buffers",
                    show_filename_only = false,
                    buffers_color = {
                        active = "lualine_b_normal",
                        inactive = "lualine_c_normal",
                    },
                    symbols = {
                        alternate_file = "",
                        directory = "󰉖 ",
                    },
                }
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
                "location"
            }
        },
    }
end

return M

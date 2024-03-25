local M = {}


function M.setup()
    local lolcrab = vim.fn.executable("lolcrab") == 1

    require"dashboard".setup {
        theme = "doom",
        preview = lolcrab and {
            command = "lolcrab -g cool",
            file_path = vim.fn.stdpath("data").."/logo.txt",
            file_width = 69,
            file_height = 8,
        },
        config = {
            header = (not lolcrab) and vim.fn.readfile(vim.fn.stdpath("data").."/logo.txt"),
            center = {
                {
                    desc = "Recent Files",
                    action = "Telescope oldfiles",
                    key = "o",
                },
                {
                    desc = "Recent Projects",
                    action = "Telescope projects",
                    key = "p",
                },
                {
                    desc = "File Browser",
                    action = "Telescope file_browser",
                    key = "f",
                },
                {
                    desc = "Show Plugins",
                    action = "Lazy",
                    key = "l",
                },
                {
                    desc = "Update Plugins",
                    action = "Lazy update",
                    key = "u",
                },
                {
                    desc = "Exit Neovim",
                    action = "qa",
                    key = "q",
                },
            },
        }
    }
end

return M

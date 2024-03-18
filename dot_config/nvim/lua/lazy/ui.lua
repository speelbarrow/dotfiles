return --[[ @as LazySpec ]] {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "Mofiqul/dracula.nvim"
        },
        priority = 600,
        config = function() require"config.lualine".setup() end
    },
    {
        "rcarriga/nvim-notify",
        priority = 300,
        config = function()
            vim.notify = require"notify"

            ---@diagnostic disable-next-line: missing-fields
            vim.notify.setup {
                background_colour = require"dracula".colors()["bg"]
            }
        end
    },
}

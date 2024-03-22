return {
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
        config = function() require"config.notify".setup() end
    },
    {
        "nvimdev/dashboard-nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        event = "VimEnter",
        config = function() require"config.dashboard".setup() end
    },
    {
        "lewis6991/gitsigns.nvim",
        priority = 200,
        init = function()
            -- This way if the plugin takes a second to load, it doesn't shift the position of the text abruptly
            vim.o.signcolumn = "yes"
        end,
        config = function() require"config.gitsigns".setup() end
    }
}

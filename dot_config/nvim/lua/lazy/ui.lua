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
            "nvim-tree/nvim-web-devicons"
        },
        event = "VimEnter",
        config = function() require"config.dashboard".setup() end
    }
}

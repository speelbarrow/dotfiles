return {
    {
        "ahmedkhalf/project.nvim",
        config = function() require("config.project").setup() end,
        priority = 450,
    },
    {
        "tpope/vim-fugitive",
    },
}

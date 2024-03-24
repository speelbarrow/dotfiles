return {
    {
        "ahmedkhalf/project.nvim",
        config = function() require"config.project".setup() end,
        priority = 450,
    },
    {
        "tpope/vim-fugitive",
        dependencies = {
            {
                "seanbreckenridge/yadm-git.vim",
                config = function() vim.g.yadm_git_gitgutter_enabled = 0 end,
            },
        },
        priority = 201,
    },
}

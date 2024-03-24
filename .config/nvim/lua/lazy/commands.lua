return {
    "famiu/bufdelete.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                "nvim-lua/plenary.nvim",
                lazy = true,
            },
            "nvim-tree/nvim-web-devicons",
        },
        cmd = "Telescope",
        config = function() require"config.telescope".setup() end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        cmd = "Telescope file_browser",
        config = function() require"telescope".load_extension "file_browser" end,
    },
    --[[{
        "nvim-telescope/telescope-ui-select.nvim",
        init = function()
            local save = vim.ui.select
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(items, opts, on_choice)
                vim.ui.select = save
                require"telescope".load_extension "ui-select"
                vim.ui.select(items, opts, on_choice)
            end
        end,
        lazy = true,
    },]]
}

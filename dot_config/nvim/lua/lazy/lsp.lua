return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            require"lsp"
        end,
        priority = 400,
    },

    -- Auto-completion
    {
        "ms-jpq/coq.nvim",
        lazy = true,
        init = function()
            vim.g.coq_settings = { auto_start = true }
        end,
        build = function()
            vim.cmd "COQdeps"
        end,
        -- config runs in `util.configure_lsp`
    },

    -- Copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function() require"config.copilot".setup() end
    },

    -- Extension to LuaLS that makes it aware of Neovim runtime files
    {
        "folke/neodev.nvim",
        lazy = true,
    },
}

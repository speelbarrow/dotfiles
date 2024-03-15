return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            require"lsp"
        end
    },

    -- Auto-completion
    {
        "ms-jpq/coq.nvim",
        event = "LspAttach",
        init = function()
            vim.g.coq_settings = { auto_start = true }
        end,
        build = function()
            vim.cmd "COQdeps"
        end,
    },

    -- Extension to LuaLS that makes it aware of Neovim runtime files
    {
        "folke/neodev.nvim",
        lazy = true,
    },
}

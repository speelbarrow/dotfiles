return {
    -- Must load before `lspconfig`
    {
        "neovim/nvim-lspconfig",
        config = function()
            require"lsp"
        end
    },

    -- Extension to LuaLS that makes it aware of Neovim runtime files
    {
        "folke/neodev.nvim",
        lazy = true,
    },
}

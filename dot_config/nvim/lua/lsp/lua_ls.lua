vim.api.nvim_create_autocmd({"BufNew", "BufReadPre"}, {
    pattern = "*.lua",
    once = true,
    callback = function()
        require"neodev".setup {}
        require"lspconfig".lua_ls.setup {}
    end
})


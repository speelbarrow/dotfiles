vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.asm",
    command = "set filetype=gas"
})

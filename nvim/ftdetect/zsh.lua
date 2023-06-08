vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = ".zshrc*",
    command = "setlocal filetype=zsh"
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(args) vim.bo[args.buf].textwidth = 119 end
})

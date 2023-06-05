vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.gohtml",
    callback = function(args)
        vim.bo[args.buf].filetype = "gohtmltmpl"
    end,
})

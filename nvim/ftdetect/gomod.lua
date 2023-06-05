vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "go.mod",
    callback = function(args)
        vim.bo[args.buf].filetype = "gomod"
    end
})

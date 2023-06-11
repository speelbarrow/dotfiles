vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.sh",
    callback = function(args)
        local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1]

        for _, regex in ipairs({ "^#!", "bash$" }) do
            if first_line:find(regex) == nil then
                return
            end
        end

        vim.bo.filetype = "bash"
    end
})

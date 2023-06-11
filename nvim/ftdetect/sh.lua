vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.sh",
    callback = function(args)
        local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1]

        if first_line:find("^#!") == nil then
            return
        end

        for _, shell in ipairs({ "bash", "zsh" }) do
            if first_line:find(shell) ~= nil then
                vim.bo[args.buf].filetype = shell
                return
            end
        end
    end
})

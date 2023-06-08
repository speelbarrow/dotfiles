return {
    setup = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "toml",
            callback = function(args)
                if args.file:find("Cargo.toml$") ~= nil then
                    vim.api.nvim_buf_set_var(args.buf, "copilot_enabled", false)
                end
            end
        })

        require'crates'.setup {}
    end
}

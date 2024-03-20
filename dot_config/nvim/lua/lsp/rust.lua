-- Set global config variable without overwriting anything it might already contain
vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, {
    server = {
        standalone = true,
        settings = {
            ["rust-analyzer"] = {
                procMacro = {
                    enable = true,
                },
                checkOnSave = true,
            },
        },
    },
})


-- Configure autocommand to inject capabalities into the LSP server when a Rust file is loaded
-- (this way we don't load `coq` before we have to)
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" },  {
    pattern = "*.rs",
    once = true,
    callback = function()
        vim.g.rustaceanvim.server = vim.tbl_deep_extend("keep",
        vim.g.rustaceanvim.server or {}, require"coq".lsp_ensure_capabilities(vim.g.rustaceanvim.server or {}))
    end
})

-- Configure an autocommand to format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function() vim.lsp.buf.format() end
})

-- Disable "recommended style" settings provided `rust.vim`
vim.g.rust_recommended_style = 0

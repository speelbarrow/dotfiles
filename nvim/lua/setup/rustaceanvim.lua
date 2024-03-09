return {
    setup = function()
        vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, {
            server = {
                standalone = true,
                settings = {
                    ["rust-analyzer"] = {
                        procMacro = {
                            enable = true
                        },
                        checkOnSave = true,
                        diagnostics = {
                            disabled = {
                                "inactive-code"
                            }
                        }
                    },
                },
            },
        })

        -- Automatically format on save (through LSP instead of rust.vim)
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.rs",
            callback = function() vim.lsp.buf.format() end,
        })

        -- Disable recommended styles provided by rust.vim, but enable RustFmt on save
        vim.g.rust_recommended_style = 0
    end
}

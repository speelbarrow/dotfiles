return {
    setup = function()
        require 'rust-tools'.setup({
            server = {
                standalone = true,
                settings = {
                    ["rust-analyzer"] = {
                        procMacro = {
                            enable = true
                        },
                        checkOnSave = {
                            command = "clippy",
                            allTargets = false,
                        },
                        diagnostics = {
                            disabled = {
                                "inactive-code"
                            }
                        }
                    }
                }
            },
        })

        -- Disable recommended styles provided by rust.vim, but enable RustFmt on save
        vim.g.rust_recommended_style = 0
        vim.g.rustfmt_autosave = 1
    end
}

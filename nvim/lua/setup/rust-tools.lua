return {
    setup = function()
        require 'rust-tools'.setup({
            server = {
                standalone = true,
            },
            settings = {
                ["rust-analyzer"] = {
                    procMacro = {
                        enable = true
                    },
                }
            }
        })

        -- Disable recommended styles provided by rust.vim
        vim.g.rust_recommended_style = 0
    end
}

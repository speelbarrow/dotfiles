return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            require"lsp"
        end,
        priority = 400,
    },

    -- Auto-completion
    {
        "ms-jpq/coq.nvim",
        lazy = true,
        init = function()
            vim.g.coq_settings = vim.tbl_deep_extend("keep", vim.g.coq_settings or {}, {
                auto_start = true,
            })
        end,
        build = function()
            vim.cmd "COQdeps"
        end,
    },

    -- Copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function() require"config.copilot".setup() end
    },

    -- Extension to LuaLS that makes it aware of Neovim runtime files
    {
        "folke/neodev.nvim",
        lazy = true,
    },

    -- Rust LSP and other goodies
    {
        "mrcjkb/rustaceanvim",
        dependencies = {
            "rust-lang/rust.vim",
            {
                "Saecki/crates.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
            },
        },
        -- Configuration found in `lsp/rust.lua`
        ft = "rust",
    },
    {
        "Saecki/crates.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",

            -- Loads `rustaceanvim` for the non-LSP features it provides
            {
                "mrcjkb/rustaceanvim",
                dependencies = {
                    "rust-lang/rust.vim"
                },
            }
        },
        event = "BufRead *Cargo.toml",
        config = true
    },
}

local M = {}

function M.setup()
    local lspconfig = require'lspconfig'
    local default_capabalities = require'cmp_nvim_lsp'.default_capabilities
    local capabilities = default_capabalities()

    -- Styling for LSP windows

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
    {border = "rounded" })

    vim.diagnostic.config { float = { border = "rounded" } }

    vim.cmd [[
    hi! NormalFloat guibg=none ctermbg=none
    hi! FloatBorder guibg=none ctermbg=none
    ]]

    -- Only load Neodev under certain conditions, as it will modify the behaviour of LuaLS
    -- (Installing and updating managed by Lazy)
    require'neodev'.setup {
        -- Don't bother with the logic for enabling/disabling Neodev because we're only loading it under certain 
        -- conditions anyway
        override = function(_, library)
            for _, path in ipairs({ vim.fn.getcwd(), vim.fn.expand('%:p') }) do
                if path:find('^'..vim.opt.rtp:get()[1]) ~= nil or
                    path:find('^'..vim.fn.fnamemodify(vim.fn.resolve(vim.env.MYVIMRC), ':h:h')) ~= nil then

                    library.enabled = true
                    library.runtime = true
                    library.types = true
                    library.plugins = true
                end
                break
            end
        end
    }


    -- LuaLS setup must occur after Neodev setup
    -- (See plugin docs for install)
    lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    checkThirdParty = false,
                    library = { vim.api.nvim_get_runtime_file('', true) },
                }
            }
        }
    }

    -- Use clangd for C/C++ LSP
    lspconfig.clangd.setup {
        capabilities = default_capabalities({ offsetEncoding = "utf-8" }),
    }

    -- CMakeLists LSP
    -- `pip install cmake-language-server`
    lspconfig.cmake.setup {
        capabilities = capabilities
    }

    -- Dockerfile LSP
    -- `npm install -g dockerfile-language-server-nodejs`
    lspconfig.dockerls.setup {
        capabilities = capabilities
    }

    -- YAML LSP (mainly for editing GitHub Actions workflows)
    -- `npm install -g yaml-language-server`
    lspconfig.yamlls.setup {
        capabilities = capabilities,
    }

    -- JSON LSP
    -- `npm install -g vscode-langservers-extracted`
    lspconfig.jsonls.setup {
        capabilities = default_capabalities({
            textDocument = {
                completion = {
                    completionItem = {
                        snippetSupport = true,
                    },
                },
            },
        }),
        settings = {
            json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
            },
        },
    }

    -- HTML/CSS/JS LSP
    -- `npm install -g vscode-langservers-extracted`
    lspconfig.html.setup {
        capabilities = default_capabalities({
            textDocument = {
                completion = {
                    completionItem = {
                        snippetSupport = true,
                    },
                },
            },
        })
    }

    -- TypeScript LSP (works for JavaScript too)
    -- `npm install -g typescript typescript-language-server`
    lspconfig.tsserver.setup {
        capabilities = capabilities
    }

    -- Markdown LSP (mostly just to trigger Dispatch setup for Markdown files)
    -- Use system package manager
    lspconfig.marksman.setup {
        capabilities = capabilities
    }

    -- Cucumber (Gherkin) LSP
    -- `npm install -g @binhtran432k/cucumber-language-server` (requires Node >= 16)
    lspconfig.cucumber_language_server.setup {
        capabilities = capabilities
    }

    -- GoPLS
    -- `go install golang.org/x/tools/gopls@latest`
    lspconfig.gopls.setup {
        capabilities = capabilities
    }

    -- Vimscript LSP
    -- `npm install -g vim-language-server`
    lspconfig.vimls.setup {
        capabilities = capabilities
    }

    -- Bash (and other shells) LSP
    -- `npm install -g bash-language-server`
    lspconfig.bashls.setup {
        capabilities = capabilities,
        filetypes = { "bash" }
    }

    -- TOML LSP
    -- `cargo install --features lsp taplo-cli`
    lspconfig.taplo.setup {
        capabilities = capabilities
    }

    -- Python LSP
    -- `pip install "python-lsp-server[all]" mypy pylsp-mypy`
    lspconfig.pylsp.setup {
        capabilities = capabilities,
        settings = {
            pylsp = {
                plugins = {
                    rope_autoimport = {
                        enabled = true
                    },
                    ruff = {
                        lineLength = 79
                    },
                }
            }
        }
    }

    -- Arduino LSP
    -- `go install github.com/arduino/arduino-language-server@latest`
    -- (Requires `clangd` and `arduino-cli`)
    lspconfig.arduino_language_server.setup {
        -- Don't override capabilities, as this LSP doesn't support them
        cmd = {
            "arduino-language-server",
            "-cli-config",
    -- Make a symlink to the arduino-cli config file in your home directory in order to maintain platform agnosticism
            vim.fn.expand('~/.arduino.yaml')
        }
    }
end

return M

local lspconfig = require'lspconfig'

-- Only load Neodev under certain conditions, as it will modify the behaviour of LuaLS
-- (Installing and updating managed by Lazy)
for _, path in ipairs({ vim.fn.getcwd(), vim.fn.expand('%:p') }) do
	if path:find('^'..vim.opt.rtp:get()[1]) ~= nil or
		path:find('^'..vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('~/.config/nvim/init.lua')), ':h:h')) ~= nil then

		require'neodev'.setup {
			-- Don't bother with the logic for enabling/disabling Neodev because we're only loading it under certain 
			-- conditions anyway
			override = function(_, library)
				library.enabled = true
				library.runtime = true
				library.types = true
				library.plugins = true
			end
		}
		break
	end
end


-- LuaLS setup must occur after Neodev setup
-- (See plugin docs for install)
lspconfig.lua_ls.setup {
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
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.offsetEncoding = "utf-8"
		return capabilities
	end)(),
}

-- CMakeLists LSP
-- `pip install cmake-language-server`
lspconfig.cmake.setup {}

-- Dockerfile LSP
-- `npm install -g dockerfile-language-server-nodejs`
lspconfig.dockerls.setup {}

-- YAML LSP (mainly for editing GitHub Actions workflows)
-- `npm install -g yaml-language-server`
lspconfig.yamlls.setup {
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.yml",
				["https://json.schemastore.org/github-action.json"] = "action.yml",
			},
		},
	},
}

-- JSON LSP
-- `npm install -g vscode-langservers-extracted`
lspconfig.jsonls.setup {
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
	settings = {
		json = {
			schemas = (function()
				local schemas = {}

				for schema, fileMatch in pairs({
					["package.json"] = { "package.json" },
					["tsconfig.json"] = { "tsconfig.json" },
				}) do
				table.insert(schemas, { fileMatch = fileMatch, url = "https://json.schemastore.org/"..schema })
			end

			return schemas
		end)(),
	},
},
}

-- HTML/CSS/JS LSP
-- `npm install -g vscode-langservers-extracted`
lspconfig.html.setup {
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- TypeScript LSP (works for JavaScript too)
-- `npm install -g typescript typescript-language-server`
lspconfig.tsserver.setup {}

-- Markdown LSP (mostly just to trigger Dispatch setup for Markdown files)
-- Use system package manager
lspconfig.marksman.setup {}

-- Cucumber (Gherkin) LSP
-- `npm install -g @binhtran432k/cucumber-language-server` (requires Node >= 16)
lspconfig.cucumber_language_server.setup {}

-- GoPLS
-- `go get golang.org/x/tools/gopls@latest`
lspconfig.gopls.setup {}

-- Vimscript LSP
-- `npm install -g vim-language-server`
lspconfig.vimls.setup {}
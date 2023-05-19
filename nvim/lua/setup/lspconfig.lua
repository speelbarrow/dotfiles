local lspconfig = require'lspconfig'

-- Only load Neodev under certain conditions, as it will modify the behaviour of LuaLS
-- (Installing and updating managed by Lazy)
if vim.fn.expand('%:p'):find('^'..vim.opt.rtp:get()[1]) ~= nil or
	vim.fn.expand('%:p'):find('^'..vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('~/.config/nvim/init.lua')), ':h')) ~= nil then

	-- Override Neodev defaults -- if we're setting it up, it should be available
	require'neodev'.setup {}

end


-- LuaLS setup must occur after Neodev setup
-- (See plugin docs for install)
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			completions = {
				callSnippet = "Replace",
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
			},
		},
	},
}

-- JSON LSP
-- npm install -g vscode-langservers-extracted
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

-- TypeScript LSP (works for JavaScript too)
-- `npm install -g typescript typescript-language-server`
lspconfig.tsserver.setup {}

-- Markdown LSP (mostly just to trigger Dispatch setup for Markdown files)
-- Use system package manager
lspconfig.marksman.setup {}

lspconfig.cucumber_language_server.setup {}

local lspconfig = require'lspconfig'
local capabilities = require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Only load Neodev under certain conditions, as it will modify the behaviour of LuaLS
if vim.fn.expand('%:p'):find('^'..vim.opt.rtp:get()[1]) ~= nil or
	vim.fn.expand('%:p'):find('^'..vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('~/.config/nvim/init.lua')), ':h')) ~= nil then

	-- Override Neodev defaults -- if we're setting it up, it should be available
	require'neodev'.setup {
		override = function(_, library)
			library.enabled = true
			library.runtime = true
			library.types = true
			library.plugins = true
		end
	}

end

-- LuaLS setup must occur after Neodev setup
lspconfig.lua_ls.setup {
	capabilities = capabilities,
}

-- Use clangd for C/C++ LSP
lspconfig.clangd.setup {
	capabilities = (function()
		local clangd_capabilities = capabilities
		clangd_capabilities.offsetEncoding = "utf-8"
		return clangd_capabilities
	end)(),
}

-- Dockerfile LSP
lspconfig.dockerls.setup {
	capabilities = capabilities,
}

-- YAML LSP (mainly for editing GitHub Actions workflows)
lspconfig.yamlls.setup {
	capabilities = capabilities,
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.yml",
			},
		},
	},
}

-- Autocommand that fires when an LSP client that isn't Copilot attaches
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		-- Only run if the client is not Copilot, and set capabilities while we're at it
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name ~= 'copilot' then
			client.config.capabilities = require 'cmp_nvim_lsp'.default_capabilities(client.config.capabilities)
			vim.api.nvim_exec_autocmds('User', { pattern = 'NotCopilot', data = { buf = args.buf } })
		end
	end
})

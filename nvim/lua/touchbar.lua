local M = {
	mappings = {
		{ label = "Hover", command = "lua vim.lsp.buf.hover()"},
		{ label = 'Rename', command = "lua vim.lsp.buf.rename()"},
		{ label = 'Diagnostic', command = "lua vim.diagnostic.open_float()"},
		{ label = 'Clear Highlight', command = "noh"},
		{ label = 'Go to Definition', command = "lua vim.lsp.buf.definition()" },
		{ label = 'Copilot: On', command = "lua require'touchbar'.toggleCopilot()"},
	}
}

function M.setup()
	vim.cmd [[
	function TouchBar()
		lua require'dotfiles.touchbar'.touchbar()
	endfunction
	]]
end

function M.touchbar()
	for i = 1, 24 do
		local mapping = M.mappings[i]
		if mapping then
			vim.cmd['TouchBarLabel']('F'..i.." '"..mapping.label.."'")
			for _, mode in ipairs{'n', 'i', 'v'} do
				vim.api.nvim_set_keymap(mode, '<F'..i..'>', "<Cmd>"..mapping.command.."<CR>", {noremap = true, silent = true})
			end
		else
			vim.cmd['TouchBarLabel']('F'..i.." ' '")
		end
	end
end

function M.toggleCopilot()
	vim.b.copilot_enabled = vim.fn['copilot#Enabled']() == 0
	if vim.b.copilot_enabled then
		M.mappings[5].label = 'Copilot: On'
	else
		M.mappings[5].label = 'Copilot: Off'
	end
	vim.cmd "call it2touchbar#RegenKeys()"
end

return M

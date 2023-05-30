local M = {}

-- Keymaps for switching buffers/windows/tabpages
for mod, cmd in pairs({
	'b',
	['M'] = { "wincmd ", 'W', 'w' },
	['C'] = "tab"
}) do
	for dir, key in pairs({
		[ cmd[2] or 'p' ] = 'char-60',
		[ cmd[3] or 'n' ] = 'char-62',
	}) do
		key = '<'..(type(mod) == "string" and (mod..'-') or '')..key..'>'
		vim.keymap.set('n', key, "<Cmd>"..(cmd[1] or cmd)..dir.."<CR>")
	end
end


-- Keymaps for function keys
-- (Define labels for touchbar)
---@type { [1]: string, [2]: function }[]
M.function_keys = {
	{ "Hover", vim.lsp.buf.hover },
	{ "Rename", vim.lsp.buf.rename },
	{ "Diagnostic", vim.diagnostic.open_float },
	{ "Clear Highlight", vim.cmd.noh },
	{ "Go to Definition", vim.lsp.buf.definition },
	-- Keep Copilot as last key in this list or this breaks
	{ "Copilot: On", function()
		vim.b.copilot_enabled = vim.fn['copilot#Enabled']() == 0
		vim.api.nvim_exec_autocmds("User", { pattern = "CopilotToggled" })
	end },
}

for index, mapping in ipairs(M.function_keys) do
	vim.keymap.set({ 'n', 'i', 'v' }, "<F" .. index .. ">", mapping[2])
end

return M

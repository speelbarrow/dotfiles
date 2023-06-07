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
local function_maps = {
    vim.lsp.buf.hover,
    vim.lsp.buf.rename,
    vim.diagnostic.open_float,
    vim.cmd.noh,
    vim.lsp.buf.definition,
    function()
        vim.b.copilot_enabled = vim.fn['copilot#Enabled']() == 0
        vim.api.nvim_exec_autocmds("User", { pattern = "CopilotToggled" })
    end
}

for index, mapping in ipairs(function_maps) do
	vim.keymap.set({ 'n', 'i', 'v' }, "<F" .. index .. ">", mapping, { noremap = true })
end

-- Set up keybinding to toggle quickfix window
vim.keymap.set('n', '<M-x>', function()
    if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
        vim.cmd "cclose"
    else
        vim.cmd "copen"
    end
end, { noremap = true })

-- Keymaps for switching buffers/windows/tabpages
for mod, cmd in pairs({
    S = 'b',
	A = { "wincmd ", 'W', 'w' },
    ["S-A"] = "tab"
}) do
	for dir, key in pairs({
		[ cmd[2] or 'p' ] = "Left",
		[ cmd[3] or 'n' ] = "Right",
	}) do
		key = "<"..mod.."-"..key..">"
		vim.keymap.set('n', key, "<Cmd>"..(cmd[1] or cmd)..dir.."<CR>")
	end
end

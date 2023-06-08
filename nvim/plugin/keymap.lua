-- Keymaps for switching buffers/windows/tabpages
for mod, cmd in pairs({
    S = 'b',
	A = { "wincmd ", 'W', 'w' },
    C = "tab"
}) do
	for dir, key in pairs({
		[ cmd[2] or 'p' ] = "Left",
		[ cmd[3] or 'n' ] = "Right",
	}) do
		key = "<"..mod.."-"..key..">"
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

-- 'CR' opens folds, 'S-CR' closes
vim.keymap.set('n', "<CR>", function()
    if vim.fn.foldclosed --[[@as function]] "." ~= -1 then
        vim.cmd.foldopen()
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), 'n', false)
    end
end, { noremap = true })
vim.keymap.set('n', "<S-CR>", function()
    if vim.fn.foldlevel --[[@as function]] "." ~= 0 then
        vim.cmd.foldclose()
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-CR>", true, true, true), 'n', false)
    end
end)

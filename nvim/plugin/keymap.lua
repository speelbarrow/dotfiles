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

-- Keymaps for function keys
local function_maps = {
    vim.lsp.buf.hover,
    vim.lsp.buf.rename,
    vim.lsp.buf.code_action,
    vim.lsp.buf.definition,
    vim.diagnostic.open_float,
    function()
        if vim.fn["copilot#Enabled"]() == 1 then
            vim.cmd "Copilot disable"
        else
            vim.cmd "Copilot enable"
        end
        vim.api.nvim_exec_autocmds("User", { pattern = "CopilotToggled" })
    end,
    vim.cmd.noh,
    function()
        if vim.bo.filetype ~= "neo-tree" then
            vim.cmd "sp | term"
            vim.api.nvim_feedkeys("i", 'n', true)
        end
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

-- 'E' opens all folds, 'C' closes all folds
for lhs, rhs in pairs {
    E = 'R',
    C = 'M'
} do
    vim.keymap.set('n', lhs, 'z'..rhs, { noremap = true })
end

-- Various telescope pickers
for key, picker in pairs {
    f = "oldfiles",
    F = "find_files",
    p = "projects",
} do
    vim.keymap.set('n', "t"..key, "<Cmd>Telescope "..picker.."<CR>")
end

vim.keymap.set('n', '<C-a>', "<Cmd>tab Git commit<CR>")
vim.keymap.set('n', '<C-s>', "<Cmd>Git push<CR>")
vim.keymap.set('n', '<C-x>', function()
    vim.cmd "tab Git commit"
    vim.api.nvim_create_autocmd("User", {
        pattern = "FugitiveChanged",
        once = true,
        command = "Git push"
    })
end)

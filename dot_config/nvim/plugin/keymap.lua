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
        --[[
        if vim.fn["copilot#Enabled"]() == 1 then
            vim.cmd "Copilot disable"
        else
            vim.cmd "Copilot enable"
        end
        vim.api.nvim_exec_autocmds("User", { pattern = "CopilotToggled" })
        ]]
    end,
    vim.cmd.noh,
    function()
        --[[
        if vim.bo.filetype ~= "neo-tree" then
            vim.cmd "sp | term"
            vim.api.nvim_feedkeys("i", 'n', true)
        end
        ]]
    end
}

for index, mapping in ipairs(function_maps) do
	vim.keymap.set({ 'n', 'i', 'v' }, "<F" .. index .. ">", mapping, { noremap = true })
end

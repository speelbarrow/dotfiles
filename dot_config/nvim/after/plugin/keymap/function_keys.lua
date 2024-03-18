local telescope = {
    builtin = require"telescope.builtin",
    themes = require"telescope.themes",
}

local function_maps = {
    vim.lsp.buf.hover,
    vim.lsp.buf.rename,
    vim.lsp.buf.code_action,
    {
        function() telescope.builtin.lsp_definitions(telescope.themes.get_cursor({})) end
    },
    vim.diagnostic.open_float,
    function()
        require"copilot.suggestion".toggle_auto_trigger()
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
	vim.keymap.set({ 'n', 'i', 'v' }, "<F" .. index .. ">", (type(mapping) == "function") and mapping or mapping[1],
    { noremap = true })
    if type(mapping) == "table" and mapping[2] then
        vim.keymap.set({ 'n', 'i', 'v' }, "<S-F" .. index .. ">", mapping[2], { noremap = true })
    end
end

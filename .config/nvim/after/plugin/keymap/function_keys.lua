local function_maps = {
    vim.lsp.buf.hover,
    function()
        require"lazy".load({
            plugins = {
                "inc-rename.nvim"
            }
        })
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>:IncRename ", true, false, true), "n", false)
    end,
    vim.lsp.buf.code_action,
    {
        function() require"telescope.builtin".lsp_definitions(require"telescope.themes".get_cursor({})) end
    },
    vim.diagnostic.open_float,
    function()
        require"copilot.suggestion".toggle_auto_trigger()
    end,
    vim.cmd.noh,
    function()
        vim.cmd "sp | term"
        vim.api.nvim_feedkeys("i", 'n', true)
    end
}

for index, mapping in ipairs(function_maps) do
    vim.keymap.set({ 'n', 'i', 'v' }, "<F" .. index .. ">", (type(mapping) == "function") and mapping or mapping[1],
    { noremap = true })
    if type(mapping) == "table" and mapping[2] then
        vim.keymap.set({ 'n', 'i', 'v' }, "<S-F" .. index .. ">", mapping[2], { noremap = true })
    end
end

vim.keymap.set("n", "<S-BS>", function()
    require"notify".dismiss({ pending = false, silent = false })
end)

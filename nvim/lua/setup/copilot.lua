return {
    setup = function()
        vim.keymap.set('i', '<S-Tab>', "<Cmd>copilot#Dismiss()<CR>")

        -- Add non-default filetypes
        vim.g.copilot_filetypes = {
            yaml = true,
            NvimTree = false,
            ["neo-tree"] = false,
            startup = false,
        }
    end
}

return {
    setup = function()
        vim.keymap.set('i', '<S-Tab>', "<Cmd>copilot#Dismiss()<CR>")

        -- Add non-default filetypes
        vim.g.copilot_filetypes = {
            yaml = true,
            NvimTree = false,
            startup = false,
        }
    end
}

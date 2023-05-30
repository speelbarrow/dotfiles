vim.api.nvim_set_keymap('i', '<S-Tab>', "copilot#Dismiss()", {
	expr = true,
	silent = true,
	script = true
})

-- Add non-default filetypes
vim.g.copilot_filetypes = {
	yaml = true,
}

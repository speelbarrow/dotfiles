-- Defined as function because it needs to be run manually the first time
local function on_read()
	require'cmp'.setup.buffer { sources = { { name = 'crates' } } }
	vim.b.copilot_enabled = false
end

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "Cargo.toml",
	callback = on_read
})

require'crates'.setup {}
on_read()

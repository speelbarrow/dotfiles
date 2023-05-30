require 'rust-tools'.setup({
	dap = {
		adapter = {
			type = 'executable',
			command = 'lldb',
			name = 'lldb',
		},
	},
	server = {
		standalone = true,
	}
})

-- Disable recommended styles provided by rust.vim
vim.g.rust_recommended_style = 0

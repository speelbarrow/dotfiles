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

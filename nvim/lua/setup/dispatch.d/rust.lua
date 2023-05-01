local dispatch = require'setup.dispatch'

dispatch.register("rust", {
	single = {
		compiler = "rustc",
		run = function()
			vim.cmd "silent make"
			vim.cmd "Start -wait=always %:p:r; rm %:p:r"
		end,
		debug = function()
			vim.cmd "silent make -g"
			vim.cmd "Start rust-lldb %:p:r; rm -r %:p:r %:p:r.dSYM"
		end,
	}
})

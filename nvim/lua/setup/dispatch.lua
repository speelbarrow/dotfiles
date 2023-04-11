-- Define compiler configs
local configs = {
	rust = {
		compiler = "cargo",
	}
}

-- Sets up autocommands for setting the compiler
for ft, opts in pairs(configs) do
	if opts.compiler then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = ft,
			callback = function()
				vim.cmd("compiler "..opts.compiler)
			end
		})
	end
end

-- Helper function to avoid repeating the same code for `:R` and `:T`
local function go(cmd)
	local config = configs[vim.bo.filetype]
	if config and config.callback then
		config.callback(cmd)
	else
		vim.cmd("Make "..cmd)
	end
end

-- Set up `:R` and `:T` commands
vim.api.nvim_create_user_command('R', function() go("run") end, {nargs = 0})
vim.api.nvim_create_user_command('T', function() go("test") end, {nargs = 0})

-- Set keymapping for closing the quickfix window
vim.api.nvim_set_keymap("n", "Q", ":ccl<CR><C-l>", {noremap = true, silent = true})

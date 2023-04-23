-- Define compiler configs
local configs = {
	rust = {
		compiler = "cargo",
	},
	javascript = {
		callback = function(cmd)
			if next(vim.lsp.buf.list_workspace_folders()) ~= nil then
				if cmd == "run" then
					vim.cmd("Start -wait=always npm start")
				end
			else
				vim.cmd("Start -wait=always node %")
			end
		end
	},
	typescript = {
		callback = function(cmd)
			if next(vim.lsp.buf.list_workspace_folders()) ~= nil then
				if cmd == "run" then
					vim.cmd("Start -wait=always npm start")
				end
			else
				vim.cmd("Start -wait=always ts-node %")
			end
		end
	},
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

-- Helper function to avoid repeating the same code for `:R/T/C`
local function go(cmd)
	local config = configs[vim.bo.filetype]
	if config and config.callback then
		config.callback(cmd)
	else
		vim.cmd("Make "..cmd)
	end
end

-- Set up `:R/T/B`,  commands
vim.api.nvim_create_user_command('R', function() go("run") end, {nargs = 0})
vim.api.nvim_create_user_command('T', function() go("test") end, {nargs = 0})
vim.api.nvim_create_user_command('B' , function() go("build") end, {nargs = 0})

-- Set up keymaps for `r/t/b`
vim.api.nvim_set_keymap("n", "r", ":R<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "t", ":T<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "b", ":B<CR>", {noremap = true, silent = true})

-- Set keymapping for closing the quickfix window
vim.api.nvim_set_keymap("n", "Q", ":ccl<CR><C-l>", {noremap = true, silent = true})

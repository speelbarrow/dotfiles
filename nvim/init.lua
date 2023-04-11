-- Editor settings (`:set` commands)
for scope, object in pairs({
	g = {
		autochdir 	= true,		-- change working directory to that of the current file
		autowrite	= true,		-- automatically save before commands like :next and :make
		showmode	= false,	-- don't show mode (e.g. -- INSERT --) because it's shown by Lualine
		splitbelow	= true, 	-- put new (horizontally split) windows below current
		splitright	= true,		-- put new (vertically split) windows to the right
	},
	w = {
		number 		= true,		-- show line numbers
	},
}) do
for option, value in pairs(object) do
	-- add the 'o' because thats what the fields are *actually* called (e.g. 'wo', 'bo')
	-- see ':help vim.o'
	vim[scope..'o'][option] = value
end
end

-- Set up autocommands for buffer-scoped options
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		for option, value in pairs({
			shiftwidth	= 4,
			tabstop		= 4,
		}) do vim.bo[option] = value end
	end
})

-- Keymaps for switching buffers
vim.api.nvim_set_keymap('n', '<', ':bp<CR><C-l>', {noremap = true})
vim.api.nvim_set_keymap('n', '>', ':bn<CR><C-l>', {noremap = true})

-- Configure plugin manager
require'setup.lazy'

-- Configure lspconfig
require'setup.lspconfig'

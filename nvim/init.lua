-- Editor settings (`:set` commands)
for scope, object in pairs({
	w = {
		number 		= true,		-- show line numbers
	},
	b = {
		tabstop		= 4,		-- number of spaces that a <Tab> in the file counts for
		shiftwidth	= 4,		-- number of spaces to use for each step of (auto)indent
	},
	g = {
		autochdir 	= true,		-- change working directory to that of the current file
		showmode	= false,	-- don't show mode (e.g. -- INSERT --) because it's shown by Lualine
		splitbelow	= true, 	-- put new (horizontally split) windows below current
		splitright	= true,		-- put new (vertically split) windows to the right
	}
}) do
	for option, value in pairs(object) do
		-- add the 'o' because thats what the fields are *actually* called (e.g. 'wo', 'bo')
		-- see ':help vim.o'
		vim[scope..'o'][option] = value
	end
end

-- Configure plugin manager
require'setup.lazy'

-- Configure lspconfig
require'setup.lspconfig'

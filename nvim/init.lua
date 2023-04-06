-- Editor settings (`:set` commands)
for scope, object in pairs({
	w = {
		number 		= true,
	},
	b = {
		tabstop		= 4,
		shiftwidth	= 4,
	},
	g = {
		autochdir 	= true,
		showmode	= false,
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

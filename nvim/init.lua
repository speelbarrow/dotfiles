vim.env.DOTFILES = vim.fn.fnamemodify(vim.fn.resolve(vim.env.MYVIMRC), ':h')
vim.o.rtp = vim.env.DOTFILES..','..vim.o.rtp

-- Global editor settings (`:set` commands)
for key, value in pairs({
	autowrite		= true,
	colorcolumn		= "+1",
    expandtab       = true,
	formatoptions	= vim.o.formatoptions .. "t",
	number 			= true,
	showmode		= false,
	shiftwidth		= 4,
	splitbelow		= true,
	splitright		= true,
	tabstop			= 4,
	termguicolors 	= true,
	textwidth		= 119,
    signcolumn      = "yes",
}) do
	vim.o[key] = value
end

-- Configure plugin manager
require'setup.lazy'

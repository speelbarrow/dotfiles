vim.o.rtp = vim.fn.fnamemodify(vim.fn.resolve(vim.env.MYVIMRC), ':h')..','..vim.o.rtp

-- Global editor settings (`:set` commands)
for key, value in pairs({
	autowrite		= true,
	colorcolumn		= "+1",
    expandtab       = true,
	foldenable		= false,
	formatoptions	= vim.o.formatoptions .. "t",
	guicursor		= vim.go.guicursor .. ",i:-blinkwait175-blinkoff150-blinkon175",
	number 			= true,
	showmode		= false,
	shiftwidth		= 4,
	splitbelow		= true,
	splitright		= true,
	tabstop			= 4,
	termguicolors 	= true,
	textwidth		= 119,
}) do
	vim.o[key] = value
end

-- Configure plugin manager
require'setup.lazy'

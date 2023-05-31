local local_exists = require'dotfiles.local-exists'

-- Run local `pre` config (if present)
if local_exists('pre') then
	require'local.pre'
end

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

-- Set baseline custom keymaps
require 'dotfiles.keymap'

-- Set tab size based on filetype
require'dotfiles.tabs'

-- Add autocommand triggered when a language server other than Copilot attaches
require 'dotfiles.not-copilot'

-- Configure plugin manager
require'dotfiles.setup.lazy'

-- Filetype-specific configuration
require'dotfiles.ft'

-- Run local `post` config (if present)
if local_exists('post') then
	require'local.post'
end

local local_exists = require'dotfiles.local_exists'

-- Run local `pre` config (if present)
if local_exists('pre') then
	require'local.pre'
end

-- Global editor settings (`:set` commands)
for key, value in pairs({
	autowrite		= true,
	colorcolumn		= "+1",
	foldenable		= false,
	guicursor		= vim.go.guicursor ..
	",i:-blinkwait175-blinkoff150-blinkon175",
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

-- Set tab size based on filetype
require'dotfiles.tabs'

-- Keymaps for switching buffers/windows/tabpages
for mod, cmd in pairs({
	'b',
	['M'] = { "wincmd ", 'W', 'w' },
	['C'] = "tab"
}) do
	for dir, key in pairs({
		[ cmd[2] or 'p' ] = 'char-60',
		[ cmd[3] or 'n' ] = 'char-62',
	}) do
		key = '<'..(type(mod) == "string" and (mod..'-') or '')..key..'>'
		vim.keymap.set('n', key, "<Cmd>"..(cmd[1] or cmd)..dir.."<CR>")
	end
end

-- Configure plugin manager
require'dotfiles.setup.lazy'

-- Filetype-specific configuration
require'dotfiles.ft'

-- Run local `post` config (if present)
if local_exists('post') then
	require'local.post'
end

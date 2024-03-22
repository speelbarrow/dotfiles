-- Global editor settings
local opts = {
	-- Auto-save on `make` (and other commands)
	autowrite = true,

	-- Add a column to show where the lines wrap
	colorcolumn = "+1",

	-- Expand tab characters into some number of spaces
	expandtab = true,

	-- 't' flag autowraps based on textwidth
	formatoptions = vim.o.formatoptions .. "t",

    -- Enable mouse reporting
    mouse = "a",

	-- Show line numbers
	number = true,

	-- `Tab` key indent amount
	shiftwidth = 4,
	tabstop = 4,

	-- Default window-splitting behaviour
	splitbelow = true,
	splitright = true,

	-- Allow 'gui' colours in terminal environment
	termguicolors = true,

	-- Document textwidth
	textwidth = 119,
}

for key, value in pairs(opts) do
	vim.o[key] = value
end

-- Download 'lazy.nvim' if necessary, make its files available
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:append(lazypath)

-- Autocommand that fires when an LSP client that isn't Copilot attaches
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		-- Only run if the client is not Copilot, and set capabilities while we're at it
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name ~= 'copilot' then
			client.config.capabilities = require'cmp_nvim_lsp'.default_capabilities(client.config.capabilities)
			vim.api.nvim_exec_autocmds('User', { pattern = 'NotCopilot', data = { buf = args.buf } })
		end
	end
})

-- Plugin configurations
require'lazy'.setup {
	-- 	  			   --
	-- QUALITY OF LIFE --
	-- 	  			   --

	-- Dispatch executions and tests asynchronously
	{
		'tpope/vim-dispatch',
		config = function()
			vim.api.nvim_create_autocmd('User', {
				pattern = 'NotCopilot',
				callback = function(args) require'setup.dispatch'.setup(args.data.buf) end
			})
		end,
	},

	-- Git diff line indicators
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require'gitsigns'.setup {}

			-- Set colours	
			vim.api.nvim_set_hl(0, 'SignColumn', {}) -- Unset background colour
			vim.api.nvim_set_hl(0, 'DiffAdd', { fg='#7bd88f', ctermfg=2 })
			vim.api.nvim_set_hl(0, 'DiffChange', { fg='#fd9353', ctermfg=4 })
			vim.api.nvim_set_hl(0, 'DiffDelete', { fg='#fc618d', ctermfg=9 })
		end,
	},

	-- Cute little status line thing
	{
		'nvim-lualine/lualine.nvim',
		config = function() require'setup.lualine' end,
	},

	-- Macbook Touch Bar integration
	{
		'eth-p/vim-it2-touchbar',

		-- Only load on Mac
		cond = vim.fn.has('mac') == 1,

		-- Set up the touchbar labels/actions
		config = function() require'touchbar'.setup() end,
	},

	--				   --
	-- LANGUAGE SERVER --
	--				   --

	-- GitHub Copilot
	{
		'github/copilot.vim',
		config = function()
			vim.api.nvim_set_keymap('i', '<S-Tab>', [[ copilot#Dismiss() ]], { expr = true, silent = true, script = true })

			-- Add non-default filetypes
			vim.g.copilot_filetypes = {
				yaml = true,
			}
		end
	},

	-- LSP configs
	{
		'neovim/nvim-lspconfig',
		config = function()
			require'setup.lspconfig'
		end,
	},

	-- Provides autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',

			-- Snippet engine
			'hrsh7th/vim-vsnip',

			-- Acutal snippets
			'rafamadriz/friendly-snippets',
		},

		lazy = true,
		event = "User NotCopilot-*",
		-- Run config on load
		config = function() require'setup.nvim-cmp' end
	},

	-- Hacks LuaLS and provides syntax awareness for Neovim libraries when editing Neovim configuration files
	{
		'folke/neodev.nvim',
		lazy = true,
	},

	-- Rust LSP and other goodies
	{
		'simrat39/rust-tools.nvim',
		ft = 'rust',
		config = function()
			require'rust-tools'.setup({
				dap = {
					adapter = {
						type = 'executable',
						command = 'lldb',
						name = 'lldb',
					},
				},
				server = {
					standalone = true,
				}
			})
		end,
		priority = 51, -- Load after nvim-cmp
	}
}

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

-- Plugin configurations
require 'lazy'.setup {
	install = { colorscheme = { 'dracula' } },
    performance = { rtp = { paths = { vim.fn.fnamemodify(vim.fn.resolve(vim.env.MYVIMRC), ':h') } } },
	spec = {
		-- Dracula theme
		{
			'dracula/vim',
			name = 'dracula',
			config = function() require'dotfiles.setup.dracula'.setup() end,

			-- Load earliest
			priority = 1000,
		},

		--                         --
		-- PROJECT/FILE MANAGEMENT --
		--                         --

		-- Tree view
		{
			'nvim-tree/nvim-tree.lua',
			dependencies = {
				-- Icons
				'nvim-tree/nvim-web-devicons',

				-- Git integration
				{
					'tpope/vim-fugitive',

					-- Disable maps by default
					init = function() vim.g.fugitive_no_maps = 1 end,
				},


			},

			-- Disable Netrw so it doesn't conflict with nvim-tree
			init = function()
				vim.g.loaded_netrw = 1
				vim.g.loaded_netrwPlugin = 1
			end,
			config = function() require'dotfiles.setup.nvim-tree'.setup() end,

			-- Load latest
			priority = 1,
		},

		-- Project detection
		{
			'ahmedkhalf/project.nvim',
			config = function() require'dotfiles.setup.project_nvim'.setup() end,
		},

		-- Git diff line indicators
		{
			'lewis6991/gitsigns.nvim',
			config = require'dotfiles.setup.gitsigns'.setup,
		},


		-- 	  	             --
		-- EXECUTION/TESTING --
		-- 	  	             --

		-- Dispatch executions and tests asynchronously
		{
			'tpope/vim-dispatch',
			config = function()
				vim.api.nvim_create_autocmd('User', {
					pattern = 'NotCopilot',
					callback = function(args) require 'dotfiles.setup.dispatch'.setup(args.data.buf) end
				})
			end,
		},

		-- Preview Markdown files
		{
			'iamcco/markdown-preview.nvim',
			ft = 'markdown',
			lazy = true,
			build = ":call mkdp#util#install()"
		},


		-- 	  	     	   --
		-- QUALITY OF LIFE --
		-- 	  			   --

		-- Cute little status line thing
		{
			'nvim-lualine/lualine.nvim',
			config = function() require'dotfiles.setup.lualine'.setup() end,
		},

		-- Macbook Touch Bar integration
		{
			'speelbarrow/vim-it2-touchbar',
			branch = 'migrate-writefile',

			-- Only load on Mac
			cond = vim.fn.has('mac') == 1,

			-- Set up the touchbar labels/actions
			config = function() require'dotfiles.setup.vim-it2-touchbar'.setup() end,
		},

		-- Provides syntax highlighting for go.mod and Go template files (amongst other things)
		{
			'fatih/vim-go',
			ft = { 'go', 'gohtmltmpl', 'gomod' },
            build = ":GoUpdateBinaries"
		},

		-- Automatically close HTML/XML tags
		{
			'alvan/vim-closetag',
			ft = { 'html', 'xml', 'gohtmltmpl' },
			init = function() vim.g.closetag_filenames = '*.html,*.xml,*.gohtml' end,
		},

		-- Close buffers better
		'famiu/bufdelete.nvim',

		--				   --
		-- LANGUAGE SERVER --
		--				   --

		-- GitHub Copilot
		{
			'github/copilot.vim',
			config = function() require'dotfiles.setup.copilot'.setup() end
		},

		-- LSP configs
		{
			'neovim/nvim-lspconfig',
			config = function() require'dotfiles.setup.lspconfig'.setup() end,
		},

		-- Provides autocompletion
		{
			'speelbarrow/nvim-cmp',
			branch = 'improve-mapping-types',
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
			event = "LspAttach",

			-- Run config on load
			config = function() require'dotfiles.setup.nvim-cmp'.setup() end,

			-- Load early
			priority = 500,
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
			dependencies = {
				-- Better syntax highlighting
				'rust-lang/rust.vim',
			},
			config = function() require'dotfiles.setup.rust-tools'.setup() end,
		},

		-- Not exactly a language server but close enough, provides better experience in Cargo.toml files
		{
			'Saecki/crates.nvim',
			dependencies = {
				'nvim-lua/plenary.nvim',
			},
			event = "BufRead Cargo.toml",
			config = function() require'dotfiles.setup.crates'.setup() end,
		},

		---            ---
		--- LOCAL SPEC ---
		---            ---

		unpack(require'dotfiles.local-exists'('lazy') and require'local.lazy' or {}),
	}
}

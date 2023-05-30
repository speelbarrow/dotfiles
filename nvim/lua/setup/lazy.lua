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
			client.config.capabilities = require 'cmp_nvim_lsp'.default_capabilities(client.config.capabilities)
			vim.api.nvim_exec_autocmds('User', { pattern = 'NotCopilot', data = { buf = args.buf } })
		end
	end
})

-- Plugin configurations
require 'lazy'.setup {
	install = { colorscheme = { 'dracula' } },
	spec = {
		-- Dracula theme
		{
			'dracula/vim',
			name = 'dracula',
			config = function()
				vim.g.dracula_full_special_attrs_support = true
				vim.g.dracula_colorterm = 0
				vim.cmd.colorscheme 'dracula'

				-- Set up some custom highlighting for NvimTree (because it doesn't link to Dracula automatically)
				vim.cmd [[
					hi! link NvimTreeGitDeleted DiffDelete
					hi! link NvimTreeGitIgnored DraculaComment
					hi! link NvimTreeExecFile DraculaRed
					hi! link NvimTreeSpecialFile DraculaFgBold
					hi! link NvimTreeGitDirty DiffChange
					hi! link NvimTreeGitMerge DraculaPurple
					hi! link NvimTreeGitNew DraculaYellow
					hi! link NvimTreeGitStaged DiffAdd
					hi! link NvimTreeGitRenamed DraculaInfoLine
					hi! link NvimTreeOpenedFile DraculaPink
				]]
			end,
			-- Load early
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
				{
					'nvim-tree/nvim-web-devicons',
					opts = {
						override = {
							go = {
								icon = '󰟓',
								color = "#519aba",
								cterm_color = "74",
								name = "Go",
							},
							["gohtml"] = {
								icon = '󰟓',
								color = "#519aba",
								cterm_color = "74",
								name = "GoHTML",
							},
							["go.mod"] = {
								icon = '󰟓',
								color = "#519aba",
								cterm_color = "74",
								name = "GoModules",
							},
						}
					}
				},

				-- Git integration
				{
					'tpope/vim-fugitive',
					init = function() vim.g.fugitive_no_maps = 1 end,
				},


			},
			init = function()
				vim.g.loaded_netrw = 1
				vim.g.loaded_netrwPlugin = 1
			end,
			config = require 'dotfiles.setup.nvim-tree'.setup,

			-- Load later
			priority = 1,
		},

		-- Project detection
		{
			'ahmedkhalf/project.nvim',
			config = function() require 'project_nvim'.setup { ignore_lsp = { 'copilot', 'lua_ls' } } end,
		},

		-- Git diff line indicators
		{
			'lewis6991/gitsigns.nvim',
			config = function()
				require 'gitsigns'.setup {
					_signs_staged_enable = true,
				}
			end,
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
			config = function() require 'dotfiles.setup.lualine' end,
		},

		-- Macbook Touch Bar integration
		{
			'eth-p/vim-it2-touchbar',

			-- Only load on Mac
			cond = vim.fn.has('mac') == 1,

			-- Set up the touchbar labels/actions
			config = function() require 'dotfiles.touchbar'.setup() end,
		},

		-- Provides syntax highlighting for go.mod and Go template files (amongst other things)
		{
			'fatih/vim-go',
			ft = { 'gohtmltmpl', 'gomod' },
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
			config = function()
				vim.api.nvim_set_keymap('i', '<S-Tab>', "copilot#Dismiss()", {
					expr = true,
					silent = true,
					script = true
				})

				-- Add non-default filetypes
				vim.g.copilot_filetypes = {
					yaml = true,
				}
			end
		},

		-- LSP configs
		{
			'neovim/nvim-lspconfig',
			config = function() require 'dotfiles.setup.lspconfig' end,
		},

		-- Provides autocompletion
		{
			'noah-friedman/nvim-cmp',
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
			config = function() require 'dotfiles.setup.nvim-cmp' end,

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
			config = function()
				require 'rust-tools'.setup({
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
		},

		---            ---
		--- LOCAL SPEC ---
		---            ---

		unpack(require'dotfiles.local_exists'('lazy') and require'local.lazy' or {}),
	}
}

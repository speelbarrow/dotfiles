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
require'lazy'.setup {
	'neovim/nvim-lspconfig',

	-- Provides autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			{
				-- Snippet engine
				'SirVer/ultisnips',
				dependencies = {
					-- Mapping for nvim-cmp because I don't understand how it works
					'quangnguyen30192/cmp-nvim-ultisnips',
					-- Actual snippets
					'honza/vim-snippets'
				},
			}
		},

		lazy = true,
		init = function (_)
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					if vim.lsp.get_client_by_id(args.data.client_id).name ~= 'copilot' then
						vim.api.nvim_exec_autocmds('User', { pattern = 'cmp' })
					end
				end
			})
		end,
		event = "User cmp",
		-- Run config on load
		config = function() require'setup.nvim-cmp' end
	},

	-- GitHub Copilot
	{
		'github/copilot.vim',
		config = function()
			-- Need to set these options or Copilot will complain that nvim-cmp is using the <Tab> keybind
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
			vim.api.nvim_set_keymap('i', '<S-Tab>', vim.fn["copilot#Dismiss"](), { noremap = true, silent = true, script = true })
		end
	},

	-- Hacks LuaLS and provides syntax awareness for Neovim libraries when editing Neovim configuration files
	{
		'folke/neodev.nvim',
		lazy = true,
	},

	-- Rust LSP and other goodies
	{
		'simrat39/rust-tools.nvim',
		dependencies = {
			-- For debugging
			'nvim-lua/plenary.nvim',
			'mfussenegger/nvim-dap',
		},

		ft = 'rust',
		config = true,
	}
}

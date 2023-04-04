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

	-- Provides syntax awareness for Neovim libraries when editing Neovim configuration files
	{
		'folke/neodev.nvim',
		config = function()
			require'neodev'.setup {
				override = function(_, library)
					-- If the plugin is being loaded, just load in everything
					library.enabled = true
					library.runtime = true
					library.types = true
					library.plugins = true
				end,
				lspconfig = true
			}
		end,

		-- Check if we're in the Neovim local config directory or in the 'config' repository
		cond = vim.fn.expand('%:p'):find('^'..vim.opt.rtp:get()[1]) ~= nil,
	}
}

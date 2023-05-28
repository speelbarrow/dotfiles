-- Create an auto-command to attempt to load a config file based on filetype
vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		pcall(require, 'dotfiles.ft.'..args.match)
	end
})

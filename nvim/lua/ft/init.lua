-- Create an auto-command to attempt to load a config file based on filetype
vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		pcall(require, 'dotfiles.ft.'..args.match)
	end
})

-- Set custom filename associations
for filetype, filename in pairs({
	gohtmltmpl = "*.gohtml",
	gomod = "go.mod",
}) do
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = filename,
		callback = function(args) vim.api.nvim_buf_set_option(args.buf, "filetype", filetype) end
	})
end

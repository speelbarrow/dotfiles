require'setup.dispatch'.register("markdown", {
	run = function() vim.cmd "MarkdownPreview" end,
})

-- Override tab sizes
local function set_tabsize(ft, size)
	vim.api.nvim_create_autocmd("Filetype", {
		pattern = ft,
		callback = function()
			vim.bo.tabstop = size
			vim.bo.shiftwidth = size
		end
	})
end
set_tabsize("bash,bindzone,sh,text,zsh", 8)
set_tabsize("yaml,markdown", 2)

-- Enable `expandtab`
for _, ft in ipairs({}) do
	vim.api.nvim_create_autocmd("Filetype", {
		pattern = ft,
		callback = function()
			vim.bo.expandtab = true
		end
	})
end

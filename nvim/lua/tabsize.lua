local function set_tabsize(ft, size)
	vim.api.nvim_create_autocmd("Filetype", {
		pattern = ft,
		callback = function()
			vim.bo.tabstop = size
			vim.bo.shiftwidth = size
		end
	})
end

set_tabsize("*", 4)
set_tabsize("sh,bash,zsh,bindzone", 8)
set_tabsize("yaml,markdown", 2)

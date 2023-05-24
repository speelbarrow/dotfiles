local M = {}

local tree = nil

function M.setup()
	-- Configure highlight groups
	vim.cmd [[
	highlight NvimTreeGitDirty ctermfg=lightyellow
	highlight NvimTreeGitStaged ctermfg=lightgreen
	highlight NvimTreeGitMerge ctermfg=magenta
	highlight NvimTreeGitNew ctermfg=lightred
	highlight NvimTreeGitIgnored ctermfg=blue
	highlight NvimTreeGitDeleted ctermfg=red

	highlight NvimTreeOpenedFile ctermfg=cyan
	]]

	-- Set up the plugin
	require'nvim-tree'.setup {
		on_attach = function(bufnr)
			-- Open on enter
			for key, modes in pairs({ ['<CR>'] = { 'n' }, ['<2-LeftMouse>'] = { 'n', 'i' } }) do
				vim.keymap.set(modes, key, require'nvim-tree.api'.node.open.edit, { buffer = bufnr })
			end
			for key, modes in pairs({ ['<S-CR>'] = { 'n' }, ['<S-LeftMouse>'] = { 'n', 'i' } }) do
				-- Shift-click/enter to replace buffer in previously selected window
				vim.keymap.set(modes, key, function()
					local save_cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
					vim.cmd.wincmd "p"
					local to_close = vim.api.nvim_get_current_buf()
					if vim.fn.getbufinfo({ bufnr = to_close })[1].changed == 1 then
						vim.notify("Buffer is modified, can't replace", vim.log.levels.ERROR)
						return
					end
					vim.cmd.wincmd "p"
					vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), save_cursor)
					require'nvim-tree.api'.node.open.edit()
					vim.api.nvim_buf_delete(to_close, {})
				end, { buffer = bufnr })
			end


			-- 'Un'-focus the tree without closing
			vim.keymap.set({'n'}, '<Esc>', '<C-w>p', { buffer = bufnr, silent = true })
			vim.keymap.set({'n'}, '<Tab>', '<C-w>p', { buffer = bufnr, silent = true })

			-- Expand all
			vim.keymap.set('n', 'E', tree.expand_all, { buffer = bufnr })

			-- Git keymaps (relies on fugitive)
			vim.keymap.set('n', 'a',
				function() vim.cmd('Git add '..vim.fn.fnamemodify(tree.get_node_under_cursor().absolute_path, ':.')) end,
				{ buffer = bufnr })
			vim.keymap.set('n', 's',
				function() vim.cmd('Git restore --staged '..vim.fn.fnamemodify(tree.get_node_under_cursor().absolute_path, ':.')) end,
				{ buffer = bufnr })
			vim.keymap.set('n', 'd',
				function() vim.cmd('Git rm --cached '..vim.fn.fnamemodify(tree.get_node_under_cursor().absolute_path, ':.')) end,
				{ buffer = bufnr })
			vim.keymap.set('n', 'RR',
				function() vim.cmd('Git checkout HEAD -- '..vim.fn.fnamemodify(tree.get_node_under_cursor().absolute_path, ':.')) end,
				{ buffer = bufnr })
			vim.keymap.set('n', 'CC', function()
				vim.cmd.tabnew()
				local to_close = vim.api.nvim_get_current_buf()
				vim.api.nvim_create_autocmd("User", {
					pattern = "FugitiveEditor",
					once = true,
					callback = function() vim.api.nvim_buf_delete(to_close, {}) end
				})
				vim.cmd('Git commit')
			end, { buffer = bufnr })
		end,
		disable_netrw = true,
		hijack_cursor = true,
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = true,
			ignore_list = {"help"}
		},
		filters = { custom = { "^\\.git" } },
		git = { enable = true },
		renderer = {
			highlight_git = true,
			highlight_opened_files = "name",
			root_folder_label = ':~:s?$?/...?',
			icons = {
				glyphs = {
					git = {
						unstaged = '!=',
						staged = '+',
						untracked = '?',
						deleted = '-',
					}
				}
			}
		}
	}

	-- Assign to `tree`
	tree = require'nvim-tree.api'.tree

	-- Set up keybind for toggling tree view
	vim.keymap.set('n', '<Tab>', tree.focus)
	vim.keymap.set('n', '<S-Tab>', function() tree.toggle({ find_file = true, focus = false }) end)

	-- Wait to be in project dir
	if vim.fn.getcwd() == require'project_nvim.project'.get_project_root() then
		tree.toggle({ find_file = true, focus = false })
	else
		vim.api.nvim_create_autocmd("DirChanged", {
			once = true,
			callback = function()
				tree.toggle({ find_file = true, focus = false })
			end
		})
	end
end

return M

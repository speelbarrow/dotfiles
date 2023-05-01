local M = {
	---@enum action Available actions that will be set up using Dispatch
	actions = {
		run = "run",
		debug = "debug",
		test = "test",
		build = "build",
	}
}

---@alias monoconfig { compiler?: string, [action]?: (fun(): nil) | string | true } Configuration of Dispatch actions for a specific FileType. Functions get called, strings passed to `Dispatch` (`true` means use the action name as a string). If the `compiler` string is defined and the action is a string, it will be prepended to the action string before being sent to Dispatch.
---@alias multiconfig { single?: monoconfig, workspace?: monoconfig } Configuration for a FileType where behaviours should differ between single-file and workspace environments.
---@alias config monoconfig | multiconfig Configuration for a FileType.

---@type { [integer]: config? }
local current_configs = {}

-- Configurations of Dispatch actions for associated FileTypes
---@type { [vim.opt.filetype]: config }
local configs = {}

---@param ft vim.opt.filetype
---@param new_config config
function M.register(ft, new_config)
	configs[ft] = new_config
end


-- Helper function to determine if the LSP client for the current buffer is running in single-file mode
---@return ("single" | "workspace")?
local function single_or_workspace()
	-- Can assume will only have one client for the current buffer (except for Copilot), so just get the first one (unless it's Copilot, then get the second)
	local clients = vim.lsp.get_active_clients({ bufnr = 0 })
	local client = clients[1]
	if client == nil then
		return nil
	end

	if client.name == "copilot" then
		client = clients[2]
	end

	-- If the client has the root_dir field, it's a workspace client (except for rust_analyzer-standalone, which has a root_dir but is a single-file client)
	if client.name ~= "rust_analyzer-standalone" and client.config.root_dir then
		return "workspace"
	else
		return "single"
	end
end


---@param action action
function M.go(action)
	-- Get the config for the current buffer
	local config = current_configs[vim.api.nvim_get_current_buf()]

	-- Check if the configuration for this filetype is a multiconfig, and if so, get the appropriate config
	-- Only continue if there is a config for this filetype	and action
	if config and config[action] then
		local action_config = config[action]

		-- If the action config is a function, call it
		if type(action_config) == "function" then
			action_config()

			-- If the action config is a string or boolean, send it to Dispatch
		else
			if action_config == true then
				action_config = action
			end
			if config.compiler then
				action_config = config.compiler .. " " .. action_config
			end
			vim.cmd("Dispatch " .. action_config)
		end
	else
		vim.notify("'" .. action .. "' action is not configured for this file", vim.log.levels.WARN)
	end
end

---@param bufnr integer
function M.setup(bufnr)
	vim.cmd "runtime! lua/setup/dispatch.d/*.lua"

	-- Set up custom commands and keybindings for each action
	for _, action in pairs(M.actions) do
		vim.api.nvim_create_user_command(action:upper():sub(1, 1), function() M.go(action) end, {})
		vim.api.nvim_set_keymap("n", "<M-" .. action:sub(1, 1) .. ">", "<cmd>" .. action:upper():sub(1, 1) .. "<CR>", { noremap = true, silent = true })
	end

	-- Set up keybinding to toggle quickfix window
	vim.api.nvim_set_keymap("n", "<M-q>", "<cmd>lua require'setup.dispatch'.toggle_quickfix()<CR>", { noremap = true, silent = true })
	function M.toggle_quickfix()
		if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
			vim.cmd "cclose"
		else
			vim.cmd "copen"
		end
	end


	-- Determine the configuration for the current buffer (this `setup` function is only called on 'LspAttach')	and add it to the `current_configs` table	
	current_configs[bufnr] = configs[vim.api.nvim_buf_get_option(bufnr, "filetype")]

	-- If the config is a multiconfig, get the appropriate config
	if current_configs[bufnr] then
		current_configs[bufnr] = current_configs[bufnr][single_or_workspace()] or current_configs[bufnr]
	end

	-- If the resulting config is not nil...
	if current_configs[bufnr] then
		-- ... set up an autocommand to remove it from the `current_configs` table when the buffer is no longer active ...
		vim.api.nvim_create_autocmd("BufDelete", {
			buffer = bufnr,
			callback = function()
				current_configs[bufnr] = nil
			end
		})

		-- ... and configure the compiler if provided
		if current_configs[bufnr].compiler then
			if not pcall(vim.cmd --[[@as any]], "compiler " .. current_configs[bufnr].compiler) then
				vim.bo.makeprg = current_configs[bufnr].compiler
			end
		end
	end
end

return M

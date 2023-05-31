local M = {
	---@enum action Available actions that will be set up using Dispatch
	actions = {
		run = "run",
		debug = "debug",
		test = "test",
		build = "build",
		clean = "clean",
	}
}

---@alias monoconfig { compiler?: (fun(bufnr: integer): nil) | string, [action]?: (fun(): nil) | string | true } Configuration of Dispatch actions for a specific FileType. Functions get called, strings passed to `Dispatch` (`true` means use the action name as a string). If `compiler` is a function, it will be executed when the file is loaded. If it is a string and the action is a string, it will be prepended to the action string before being sent to Dispatch. As well, when the configuration is loaded it set the vim compiler option if available, or the 'b:makeprg' variable otherwise
---@alias multiconfig { single?: monoconfig, workspace?: monoconfig } Configuration for a FileType where behaviours should differ between single-file and workspace environments.
---@alias config monoconfig | multiconfig Configuration for a FileType.

---@type { [integer]: config? }
local current_configs = {}

-- Configurations of Dispatch actions for associated FileTypes
---@type { [vim.opt.filetype]: config }
Configs = {}

---@param ft vim.opt.filetype
---@param new_config config
function M.register(ft, new_config)
	Configs[ft] = new_config
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
			if config.compiler and type(config.compiler) == "string" then
				action_config = config.compiler .. " " .. action_config
			end
			vim.cmd("Dispatch " .. action_config)
		end
	else
		vim.notify("'" .. action .. "' action is not configured for this file", vim.log.levels.WARN)
	end
end

local run_once = false
---@param bufnr integer
function M.setup(bufnr)
	if not run_once then
		vim.cmd "runtime! lua/dotfiles/setup/dispatch.d/*.lua"

		vim.api.nvim_create_augroup("dotfiles.dispatch", {})

		run_once = true
	end

	-- Set up custom commands and keybindings for each action
	for _, action in pairs(M.actions) do
		vim.api.nvim_create_user_command(action:upper():sub(1, 1), function() M.go(action) end, {})
		vim.api.nvim_set_keymap("n", "<M-" .. action:sub(1, 1) .. ">", "<cmd>" .. action:upper():sub(1, 1) .. "<CR>", { noremap = true, silent = true })
	end

	-- Set up keybinding to toggle quickfix window
	vim.api.nvim_set_keymap("n", "<M-x>", "<cmd>lua require'dotfiles.setup.dispatch'.toggle_quickfix()<CR>", { noremap = true, silent = true })
	function M.toggle_quickfix()
		if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
			vim.cmd "cclose"
		else
			vim.cmd "copen"
		end
	end


	-- Determine the configuration for the current buffer (this `setup` function is only called on 'LspAttach')	and add it to the `current_configs` table	
	current_configs[bufnr] = Configs[vim.api.nvim_buf_get_option(bufnr, "filetype")]

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
			if type(current_configs[bufnr].compiler) == "function" then
				current_configs[bufnr].compiler(bufnr)
			else
				if not pcall(vim.cmd --[[@as any]], "compiler " .. current_configs[bufnr].compiler) then
					vim.bo.makeprg = current_configs[bufnr].compiler
				end
			end
		end
	end
end

-- Helper function to determine what debuggers are available and which to use
---@return string?
function M.debugger()
	if vim.fn.executable "lldb" == 1 then
		return "lldb"
	elseif vim.fn.executable "gdb" == 1 then
		return "gdb"
	else
		vim.notify("No debuggers available. Please install `lldb` or `gdb`.", vim.log.levels.ERROR)
		return nil
	end
end

-- Helper function to attempt building using `Dispatch` command (silently), and set up an autocommand to run a callback upon successful build
---@param callback (fun(): nil) Function to call after building (if successful)
---@param args string? Arguments to pass to `Dispatch`
function M.build_verify_callback(callback, args)
	for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "QuickFixCmdPost" })) do
		if autocmd.pattern == "make" and autocmd.group_name == "dotfiles.dispatch" then
			vim.notify("Trying to run a build with a pending callback while one already exists. Please wait.", vim.log.levels.ERROR)
			return
		end
	end
	vim.api.nvim_create_autocmd("QuickFixCmdPost", {
		pattern = "make",
		group = "dotfiles.dispatch",
		once = true,
		callback = function()
			if next(vim.fn.getqflist()) == nil then
				callback()
			end
		end,
	})
	vim.cmd("Dispatch " .. (args or ""))
end

return M

-- Quick helper function to determine if a local config file/module exists
---@param submodule string
---@return boolean
local function local_exists(submodule)
	return vim.fn.filereadable(vim.api.nvim_list_runtime_paths()[1]..'/lua/local/'..submodule..'.lua') ~= 0 or vim.fn.filereadable(vim.api.nvim_list_runtime_paths()[1]..'/lua/local/'..submodule..'/init.lua') ~= 0
end

return local_exists

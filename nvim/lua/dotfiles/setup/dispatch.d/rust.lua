local dispatch = require'dotfiles.setup.dispatch'

-- Helper function that determines all binary targets in a Cargo.toml file and then launches them
---@param todo string
local function do_if_target(todo)
	local targets = vim.json.decode(vim.fn.system("cargo read-manifest")).targets

	-- Function to actually run a target to avoid code duplication
	---@param target table
	local function run(target)
		-- Get root dir
		local root = vim.fn.fnamemodify(vim.fn.system("cargo locate-project --message-format=plain"), ":p:h")

		-- Build the project, and execute the command if successful
		dispatch.build_verify_callback(function()
			vim.cmd("Start "..todo.." "..root.."/target/debug/"..target.name)
		end, " -compiler=cargo -dir="..root.." -- build")
	end

	-- Check for `default-run` field, if none we will just run the first listed in manifest file
	local default_run = vim.json.decode(vim.fn.system("cargo read-manifest"), { luanil = { object = true, array = true } })["default-run"]
	if default_run ~= nil then
		run(default_run)
	end

	-- Find the first binary target (usually only one anyways), then update program state accordingly
	for _, target in ipairs(targets) do
		if target.kind[1] == "bin" then
			run(target)
			return
		end
	end

	vim.notify("No binary target found", vim.log.levels.ERROR)
end

dispatch.register("rust", {
	single = {
		compiler = "rustc",
		run = function() dispatch.build_verify_callback(function() vim.cmd "Start -wait=always %:p:r; rm %:p:r" end) end,
		debug = function()
			local debugger = dispatch.debugger()
			if debugger == nil then return end
			dispatch.build_verify_callback(function()
				vim.cmd("Start rust-"..debugger.." %:p:r; 2>/dev/null rm -r %:p:r.dSYM; rm %:p:r")
			end, "-- -g")
		end,
	},
	workspace = {
		compiler = "cargo",

		-- Override default behaviour and call `Start` because it is possible we will need an interactive prompt
		run = function() do_if_target("-wait=always") end,

		debug = function()
			local debugger = dispatch.debugger()
			if debugger == nil then return end
			do_if_target("rust-"..debugger)
		end,
		test = true,
		build = true,
		clean = true,
	}
})

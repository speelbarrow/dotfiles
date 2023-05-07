-- Helper function that determines all binary targets in a Cargo.toml file and then launches them
---@param todo string
local function do_if_target(todo)
	local targets = vim.json.decode(vim.fn.system("cargo read-manifest")).targets

	-- Find all binary targets, if at least one is found then update program state accordingly
	local none = true
	for _, target in ipairs(targets) do
		if target.kind[1] == "bin" then
			none = false

			-- Only two possible LSP clients, if the first is copilot just use second
			local clients = vim.lsp.get_active_clients()
			local client = clients[1]
			if client.name == "copilot" then
				client = clients[2]
			end

			-- Build the project
			vim.cmd "silent make build"

			-- Execute the command
			vim.cmd("Start " .. todo .. " " .. client.config.root_dir .. "/target/debug/" .. target.name)
		end
	end

	if none then
		vim.notify("No binary target found", vim.log.levels.ERROR)
	end
end

require'setup.dispatch'.register("rust", {
	single = {
		compiler = "rustc",
		run = function()
			vim.cmd "silent make"
			vim.cmd "Start -wait=always %:p:r; rm %:p:r"
		end,
		debug = function()
			vim.cmd "silent make -g"
			vim.cmd "Start rust-lldb %:p:r; rm -r %:p:r %:p:r.dSYM"
		end,
	},
	workspace = {
		compiler = "cargo",

		-- Override default behaviour and call `Start` because it is possible we will need an interactive prompt
		run = function() do_if_target("-wait=always") end,

		debug = function() do_if_target("rust-lldb") end,
		test = true,
		build = true,
	}
})

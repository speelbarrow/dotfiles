local dispatch = require'dotfiles.setup.dispatch'

-- Helper function to get the name of a Go module by parsing the `go.mod` file as JSON
---@return string
local function modname()
	return vim.json.decode(vim.fn.system("go mod edit -json " .. vim.fn.getcwd() .. "/go.mod")).Module.Path
end

dispatch.register("go", {
	single = {
		compiler = "go",
		run = function() vim.cmd "Start -wait=always go run %" end,
		debug = function()
			dispatch.build_verify_callback(function()
				vim.cmd("Start dlv exec debug; rm debug")
			end, "go build -o debug %")
		end,
		build = function() vim.cmd "Dispatch go build %" end,
	},
	workspace = {
		compiler = "go",
		run = function() vim.cmd("Start -wait=always go run " .. modname()) end,
		debug = function()
			dispatch.build_verify_callback(function()
				vim.cmd("Start dlv exec debug; rm debug")
			end, "go build -o debug "..modname())
		end,
		build = function() vim.cmd("Dispatch go build "..modname()) end,
		test = function() vim.cmd("Dispatch go test -v "..modname()) end
	}
})

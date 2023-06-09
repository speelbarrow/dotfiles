local dispatch = require'setup.dispatch'

---@param outpath string
---@param after string?
---@param build_args string?
local function debug(outpath, after, build_args)
    return dispatch.build_and_run(function()
        local debugger = dispatch.get_debugger()
        if debugger == nil then return end

        vim.cmd("Start rust-"..debugger.." "..outpath.."; "..(after or ""))
    end, build_args)
end

local function single()
    dispatch.configure_buffer {
        compiler = "rustc",
        run = dispatch.build_and_run("-wait=always trap ':' SIGINT; ./%:r; rm %:r"),
        debug = debug("%:r", "rm %:r; { [ -e %:r.dSYM ] && rm -r %:r.dSYM; return 0 }", "-g"),
        build = "%",
        clean = function() vim.cmd "silent !rm -r %:r %:r.dSYM" end
    }
end

local function workspace()
    local outpath = "target/debug/"..vim.json.decode(vim.fn.system("cargo read-manifest")).name

    dispatch.configure_buffer {
        compiler = "cargo",
        run = dispatch.build_and_run("-wait=always ./"..outpath),
        debug = debug(outpath),
        test = true,
        build = true,
        clean = true
    }
end

vim.api.nvim_create_autocmd("LspAttach", {
    buffer = 0,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client.name == "rust_analyzer" then
            if client.config.root_dir ~= nil then
                workspace()
            end
        end
    end
})
single()

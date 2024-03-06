local dispatch = require'setup.dispatch'

-- Fix an issue where Copilot's filetyping mechanism causes this script to be called
if vim.bo.filetype == "copilot.rust" then return end

---@param outpath string
---@param after string?
---@param build_args string?
local function debug(outpath, after, build_args)
    local debugger = dispatch.get_debugger()
    if debugger == nil then
        return function() vim.notify("No debugger found", vim.log.levels.WARN) end
    end

    return dispatch.build_and_run({
        cmd = "rust-"..debugger.." "..outpath.."; "..(after or ""),
        interactive = true
    }, build_args)
end

local function single()
    dispatch.configure_buffer {
        compiler = "rustc",
        run = dispatch.build_and_run({
            cmd = "trap ':' SIGINT; ./%:r; rm %:r",
            interactive = true,
            persist = true,
        }),
        debug = debug("%:r", "rm %:r; { [ -e %:r.dSYM ] && rm -r %:r.dSYM; return 0 }", "-g"),
        test = dispatch.build_and_run({
            cmd = "trap ':' SIGINT; ./%:r; rm %:r",
            interactive = true,
            persist = true,
        }, "--test"),
        build = "%",
        clean = function() vim.cmd "silent !rm -r %:r %:r.dSYM" end
    }
end

local function workspace()
    local outpath = "target/debug/"..vim.json.decode(vim.fn.system("(cd "..vim.fn.expand("%:p:h")
    .." && cargo read-manifest)")).name

    dispatch.configure_buffer {
        compiler = "cargo",
        run = {
            cmd = "r",
            interactive = true,
            persist = true
        },
        debug = debug(outpath),
        test = {
            cmd = "t",
            interactive = true,
            persist = true
        },
        build = "b",
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

if not (vim.lsp.get_active_clients({ name = "rust_analyzer" }) ~= nil and pcall(workspace)) then
    single()
end

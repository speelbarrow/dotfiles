local M = {}

---@alias Dispatch.Handler.String string | true
---@alias Dispatch.Handler.Function fun(): nil
---@alias Dispatch.Handler Dispatch.Handler.String | Dispatch.Handler.Function

---@class Dispatch.Config
---@field compiler? string
---@field run? Dispatch.Handler
---@field debug? Dispatch.Handler
---@field test? Dispatch.Handler
---@field build? Dispatch.Handler
---@field clean? Dispatch.Handler

---@param config Dispatch.Config
function M.configure_buffer(config)
    if config.compiler then
        if not pcall(vim.cmd--[[@as any]], "compiler " .. config.compiler) then
            vim.bo.makeprg = config.compiler
        end
    end

    for _, action in ipairs({ "run", "debug", "test", "build", "clean" }) do
        if config[action] == true then
            config[action] = action
        end
    end

    vim.b.dispatch_config = config
end

function M.setup()
    for _, action in ipairs({ "run", "debug", "test", "build", "clean" }) do
        local char = action:sub(1,1)

        vim.api.nvim_create_user_command(char:upper(), function(args)
            if vim.b.dispatch_config and vim.b.dispatch_config[action] then
                local handler = vim.b.dispatch_config[action]

                if type(handler) == "function" then
                    handler()
                elseif type(handler) == "string" then
                    vim.cmd("Dispatch "..(vim.b.dispatch_config.compiler or "").." "..handler.." "..(args.args or ""))
                end
            else
                vim.notify("The '" .. action .. "' action is not configured for this buffer", vim.log.levels.ERROR)
            end
        end, { nargs = "*" })

        vim.keymap.set({'n', 'i', 'v'}, "<A-" .. char .. ">", "<Cmd>"..char:upper().."<CR>", { noremap = true })
    end

    vim.api.nvim_create_augroup("Dispatch", {})
end

---@param run Dispatch.Handler
---@param build_args string?
---@return Dispatch.Handler.Function
function M.build_and_run(run, build_args)
    return function()
        if next(vim.api.nvim_get_autocmds({
                event = "QuickFixCmdPost",
                group = "Dispatch",
                buffer = 0,
            })) ~= nil then
            vim.notify("A build with a pending 'run' callback is already in progress", vim.log.levels.ERROR)
        end

        local handler = run

        if type(run) == "string" then
            handler = function() vim.cmd("Start "..run) end
        end

        vim.api.nvim_create_autocmd("QuickFixCmdPost", {
            group = "Dispatch",
            pattern = "make",
            once = true,
            callback = vim.schedule_wrap(function()
                if next(vim.fn.getqflist()) == nil then
                    handler()
                end
            end),
        })

        vim.cmd("B " .. (build_args or ""))
    end
end

---@return string?
function M.get_debugger()
    for _, debugger in ipairs { "lldb", "gdb" } do
        if vim.fn.executable(debugger) == 1 then
            return debugger
        end
    end

    vim.notify("No debugger found", vim.log.levels.ERROR)
end

return M

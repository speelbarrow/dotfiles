local M = {}

---@alias Dispatch.Handler.String string | true
---@alias Dispatch.Handler.Function fun(): nil
---@alias Dispatch.Handler.Interactive { cmd: Dispatch.Handler.String, interactive: true, persist?: true }
---@alias Dispatch.Handler Dispatch.Handler.String | Dispatch.Handler.Function | Dispatch.Handler.Interactive

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
                vim.cmd 'w'
                local handler = vim.b.dispatch_config[action]

                if type(handler) == "function" then
                    handler()
                elseif type(handler) == "string" or (type(handler) == "table" and handler.cmd ~= nil
                    and (type(handler.cmd) == "string" or handler.cmd == true) and handler.interactive) then

                    local cmd_prefix = "Dispatch"
                    if type(handler) == "table" then
                        cmd_prefix = "Start"..(handler.persist and " -wait=always" or "")
                        handler = handler.cmd
                    end

                    vim.cmd(cmd_prefix.." "..(vim.b.dispatch_config.compiler or "").." "..(handler == true and action or handler).." "..
                        (args.args or ""))
                else
                    vim.notify("Invalid handler for the '" .. action .. "' action", vim.log.levels.ERROR)
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
            handler = function() vim.cmd("Dispatch "..run) end
        elseif type(run) == "table" and run.cmd ~= nil and (type(run.cmd) == "string" or run.cmd == true)
            and run.interactive then
            handler = function() vim.cmd("Start"..(run.persist and " -wait=always" or "").." "..(run.cmd or "run")) end
        else
            vim.notify("Invalid handler for the 'build and run' action", vim.log.levels.ERROR)
            return
        end

        vim.api.nvim_create_autocmd("QuickFixCmdPost", {
            group = "Dispatch",
            pattern = "make",
            once = true,
            callback = vim.schedule_wrap(function()
                for _, line in ipairs(vim.fn.getqflist()) do
                    if line.type == "E" then
                        return
                    end
                end
                handler()
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

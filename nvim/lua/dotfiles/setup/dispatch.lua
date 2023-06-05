local M = {}

---@alias Dispatch.Handler.String string
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

    vim.b.dispatch = config
end

function M.setup()
    for _, action in ipairs({ "run", "debug", "test", "build", "clean" }) do
        local char = action:sub(1,1)

        vim.api.nvim_create_user_command(char:upper(), function()
            if vim.b.dispatch and vim.b.dispatch[action] then
                local handler = vim.b.dispatch[action]

                if type(handler) == "function" then
                    handler()
                elseif type(handler) == "string" then
                    vim.cmd("Dispatch " .. (vim.b.dispatch.compiler or "") .. " " .. handler)
                end
            else
                vim.notify("The '" .. action .. "' action is not configured for this buffer", vim.log.levels.ERROR)
            end
        end, {})

        vim.keymap.set({'n', 'i', 'v'}, "<M-" .. char .. ">", "<Cmd>"..char:upper().."<CR>", { noremap = true })
    end

    vim.api.nvim_create_augroup("Dispatch", {})
end

---@param build Dispatch.Handler.String
---@param run Dispatch.Handler
function M.build_and_run(build, run)
    if next(vim.api.nvim_get_autocmds({
        event = "QuickFixCmdPost",
        group = "Dispatch",
        buffer = 0,
    })) ~= nil then
        vim.notify("A build with a pending 'run' callback is already in progress", vim.log.levels.ERROR)
    end

    local handler = run

    if type(run) == "string" then
        local command_string = "Start "..(vim.b.dispatch.compiler or "").." "..run
        handler = function()
            vim.cmd(command_string)
        end
    end

    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        group = "Dispatch",
        buffer = 0,
        once = true,
        callback = function()
            if next(vim.fn.getqflist()) == nil then
                handler()
            end
        end,
    })

    vim.cmd("Dispatch "..(vim.b.dispatch.compiler or "").." "..build)
end

return M

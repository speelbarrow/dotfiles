vim.api.nvim_create_augroup("ConfigureLsp", {})

---@param lsp string
---@param pattern? string | string[]
---@param config? table
---@param pre? fun(args: table)
---@param post? fun(args: table)
---@param override_capabilities? false
return function(lsp, pattern, config, pre, post, override_capabilities)
    ---@param args? table
    local callback = function(args)
        if pre then
            pre(args or {})
        end

        require("lspconfig"
        )[lsp].setup((not override_capabilities) and require"coq".lsp_ensure_capabilities(config or {}))

        if post then
            post(args or {})
        end
    end

    if pattern then
        vim.api.nvim_create_autocmd({ "BufNew", "BufReadPre" }, {
            group = "ConfigureLsp",
            once = true,
            pattern = pattern,
            callback = callback,
        })
    else
        callback()
    end
end

require"util.configure_lsp"("lua_ls", "*.lua", {
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = {
                checkThirdParty = false,
                library = { vim.api.nvim_get_runtime_file('', true) },
            }
        }
    }
}, function(_)
    require"neodev".setup({
        override = function(root_dir, library)
            local paths = {
                (function()
                    local r = vim.fn.stdpath("config")
                    if type(r) == "table" then
                        r = r[1]
                    end
                    return r
                end)()
            }
            paths[2] = paths[1]:gsub("/nvim", "/local/nvim")

            for _, path in ipairs(paths) do
                if root_dir:find(path, 1, true) == 1 then
                    library.enabled = true
                    library.runtime = true
                    library.types = true
                    library.plugins = true
                    return
                end
            end
        end
    })
end)

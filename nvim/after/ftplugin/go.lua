local dispatch = require"dotfiles.setup.dispatch"

---@param buildpath string
---@param outpath string
---@return Dispatch.Config
local function base(buildpath, outpath)
    return {
        compiler = "go",
        run = dispatch.build_and_run("-wait=always ./"..outpath.."; rm "..outpath),
        debug = dispatch.build_and_run("dlv exec "..outpath.."; rm "..outpath),
        build = function() vim.cmd("Make "..buildpath) end,
        clean = function() vim.cmd("silent !rm "..outpath) end,
    }
end

local function single()
    dispatch.configure_buffer(base(vim.fn.expand("%"), vim.fn.expand("%:t:r")))
end

---@param root_dir string
local function workspace(root_dir)
    local buildpath = vim.json.decode(vim.fn.system("go mod edit -json "..root_dir.."/go.mod")).Module.Path
    local outpath = buildpath

    local front, back = buildpath:find("/[^/]+$")
    if front ~= nil then
        outpath = buildpath:sub(front + 1, back)
    end

    local config = base(buildpath, outpath)
    config.test = function() vim.cmd("Dispatch go test -v "..buildpath) end
    dispatch.configure_buffer(config)
end

vim.api.nvim_create_autocmd("LspAttach", {
    buffer = 0,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client.name == "gopls" then
            if client.config.root_dir ~= nil then
                workspace(client.config.root_dir)
            end
        end
    end
})
single()

-- Enable inlay hints
vim.api.nvim_create_augroup("LspInlayHints", {})
vim.api.nvim_create_autocmd("BufNew", {
    group = "LspInlayHints",
    callback = function(args1)
        vim.api.nvim_create_autocmd("LspAttach", {
            group = "LspInlayHints",
            buffer = args1.buf,
            once = true,
            callback = function(args2)
                vim.lsp.inlay_hint.enable(args2.buf)
            end
        })
    end
})

-- Load configurations
require"util.require_dir"("lsp")

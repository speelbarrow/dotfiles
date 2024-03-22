for _, action in ipairs({ "hover", "signatureHelp" }) do
    vim.lsp.handlers["textDocument/"..action] = vim.lsp.with(
    vim.lsp.handlers[action:gsub("([A-Z])", function(c) return "_"..c:lower() end)], { border = "rounded" })
end

vim.diagnostic.config {
    float = {
        border = "rounded"
    }
}

-- Kinda weird way to set up the inlay hints but this way it triggers exactly once per buffer
local function inlay_hint_callback(args1)
    vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspInlayHints",
        buffer = args1.buf,
        once = true,
        callback = function(args2)
            vim.lsp.inlay_hint.enable(args2.buf)
        end
    })
end
vim.api.nvim_create_augroup("LspInlayHints", {})
vim.api.nvim_create_autocmd("BufEnter", {
    group = "LspInlayHints",
    callback = inlay_hint_callback
})
vim.api.nvim_create_autocmd("BufNew", {
    group = "LspInlayHints",
    callback = inlay_hint_callback
})

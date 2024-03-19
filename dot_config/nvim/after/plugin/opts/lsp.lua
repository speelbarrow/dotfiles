for _, action in ipairs({ "hover", "signatureHelp" }) do
    vim.lsp.handlers["textDocument/"..action] = vim.lsp.with(
        vim.lsp.handlers[action:gsub("([A-Z])", function(c) return "_"..c:lower() end)], { border = "rounded" })
end

vim.diagnostic.config {
    float = {
        border = "rounded"
    }
}

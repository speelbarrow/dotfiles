vim.bo.textwidth = 119

vim.lsp.start({
    name = "rhai-lsp",
    cmd = {"rhai", "lsp", "stdio"},
    root_dir = vim.fn.expand('%:p:h')
}, { bufnr = 0 })

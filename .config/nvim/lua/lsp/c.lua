require"util.configure_lsp"("clangd", { "*.c", "*.cpp", "*.h", "*.hpp" }, {
    capabilities = {
        offsetEncoding = "utf-8"
    }
})

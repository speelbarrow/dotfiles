vim.opt.rtp:prepend(vim.fn.stdpath("data").."/lazy/lazy.nvim")
require("lazy").setup {
    table.unpack(require"lazy.theme"),
    table.unpack(require"lazy.lsp")
}

table.unpack = table.unpack or unpack

vim.opt.rtp--[[ @as vim.Option ]]:prepend(vim.fn.stdpath("data").."/lazy/lazy.nvim")
require"lazy".setup {
    spec = vim.iter(ipairs(require("util.require_dir")("lazy"))):map(function(_, value)
        return unpack(value)
    end):totable(),
    install = {
        colorscheme = { "dracula" }
    }
}

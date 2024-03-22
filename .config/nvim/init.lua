table.unpack = table.unpack or unpack

vim.opt.rtp--[[ @as vim.Option ]]:prepend(vim.fn.stdpath("data").."/lazy/lazy.nvim")
vim.opt.rtp--[[ @as vim.Option ]]:prepend(vim.fn.stdpath("config").."/../local/nvim")

require"lazy".setup {
    spec = {
        -- Synced spec
        vim.iter(ipairs(require("util.require_dir")("lazy"))):map(function(_, value)
            return table.unpack(value)
        end):totable(),

        -- Local spec
        vim.iter(ipairs(require("util.require_dir")("local/lazy", vim.fn.stdpath("config").."/../local/nvim/lua/"))):map(
        function(_, value)
            return table.unpack(value)
        end):totable()
    },
    install = {
        colorscheme = { "dracula" }
    }
}

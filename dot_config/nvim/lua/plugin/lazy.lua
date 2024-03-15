local M = {}

function M.setup()
    vim.opt.rtp:prepend(vim.fn.stdpath("data").."/lazy/lazy.nvim")
    require("lazy").setup()
end

return M

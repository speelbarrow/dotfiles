vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

-- Use MarkdownPreview plugin with Dispatch action system
require'setup.dispatch'.configure_buffer {
    run = function() vim.cmd "MarkdownPreview" end
}

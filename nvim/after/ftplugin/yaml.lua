vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

if vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()):match("/.github/workflows/.*%.ya?ml$") ~= nil then
    vim.b.dispatch_config = { run = "act" }
end

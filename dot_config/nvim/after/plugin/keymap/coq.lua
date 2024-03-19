local copilot = require"copilot.suggestion"

vim.keymap.set("i", "<S-BS>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-e>"
    elseif copilot.is_visible() then
        copilot.dismiss()
    end
end, { expr = true })

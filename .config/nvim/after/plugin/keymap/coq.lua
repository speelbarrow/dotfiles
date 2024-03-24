vim.keymap.set("i", "<S-BS>", function()
    local copilot = require"copilot.suggestion"

    if vim.fn.pumvisible() == 1 then
        return "<C-e>"
    elseif copilot.is_visible() then
        copilot.dismiss()
    else
        return "<S-BS>"
    end
end, { expr = true })

vim.g.coq_settings = vim.tbl_deep_extend("keep", vim.g.coq_settings or {}, {
    keymap = {
        bigger_preview = "<S-Enter>",
        jump_to_mark = "<M-c>",
    }
})

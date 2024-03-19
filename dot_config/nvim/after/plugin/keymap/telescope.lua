local prefix = "<M-v>"
vim.keymap.set({"n", "i", "v"}, prefix, "<Cmd>Telescope<CR>")

for picker, key in pairs(require"util.json"(vim.fn.stdpath("data").."/telescope_keys.json") or {}) do
    vim.keymap.set({"n", "i", "v"}, prefix..key, "<Cmd>Telescope "..picker.."<CR>")
end

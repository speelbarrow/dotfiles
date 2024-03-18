local prefix = "<C-t>"

vim.keymap.set({"n", "i"}, prefix, "<Cmd>Telescope<CR>")
for key, picker in pairs({
    f = "file_browser",
    o = "oldfiles",
    p = "projects",
}) do
    vim.keymap.set({"n", "i"}, prefix.."<C-"..key..">", "<Cmd>Telescope "..picker.."<CR>")
end
vim.keymap.set({"n", "i"}, prefix.."<C-f>", "<Cmd>Telescope file_browser<CR>")
vim.keymap.set({"n", "i"}, prefix.."<C-o>", "<Cmd>Telescope oldfiles<CR>")

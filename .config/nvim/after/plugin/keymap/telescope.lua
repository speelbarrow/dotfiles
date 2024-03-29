local prefix = "<M-v>"
vim.keymap.set({"n", "i", "v"}, prefix, "<Cmd>Telescope<CR>")

for key, picker in pairs({
    f = "file_browser",
    l = "file_browser path=%:p:h",
    o = "oldfiles",
    p = "projects",
    n = "notify",
    h = "highlights",
}) do
    vim.keymap.set({"n", "i", "v"}, prefix..key, "<Cmd>Telescope "..picker.."<CR>")
end

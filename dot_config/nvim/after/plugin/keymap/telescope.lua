local prefix = "<C-t>"

vim.keymap.set({"n", "i"}, prefix, "<Cmd>Telescope<CR>")
vim.keymap.set({"n", "i"}, prefix.."<C-f>", "<Cmd>Telescope file_browser<CR>")
vim.keymap.set({"n", "i"}, prefix.."<C-o>", "<Cmd>Telescope oldfiles<CR>")

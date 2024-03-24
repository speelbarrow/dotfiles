local leader = "<M-g>"

for mapping, action in pairs({
    a = "<Cmd>Gitsigns stage_hunk<CR>",
    r = "<Cmd>Gitsigns reset_hunk<CR>",
    u = "<Cmd>Gitsigns undo_stage_hunk<CR>",
    d = "<Cmd>Gitsigns preview_hunk<CR>",
    c = "<Cmd>tab Git commit<CR>",
    p = "<Cmd>Git push<CR>",
    x = function()
        vim.cmd "tab Git commit"
        vim.api.nvim_create_autocmd("User", {
            pattern = "FugitiveChanged",
            once = true,
            command = "Git push"
        })
    end,
    A = "<Cmd>Gitsigns stage_buffer<CR>",
    R = "<Cmd>Git reset_buffer<CR>",
    C = "<Cmd>tab Git commit --amend<CR>",
    P = "<Cmd>Git push -f<CR>",
    X = function()
        vim.cmd "tab Git commit --amend"
        vim.api.nvim_create_autocmd("User", {
            pattern = "FugitiveChanged",
            once = true,
            command = "Git push -f"
        })
    end,
}) do
    vim.keymap.set({ "n", "i", "v" }, leader..mapping, action)
end

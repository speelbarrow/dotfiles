return {
    {
        "Mofiqul/dracula.nvim",
        config = function()
            require'dracula'.setup {
                colors = {
                    menu = "none"
                },
                transparent_bg = true,
                italic_comment = true,
                show_end_of_buffer = true,
                overrides = function (_) return {} end
            }
            vim.cmd.colorscheme "dracula"
        end,
        priority = 1000,
    }
}

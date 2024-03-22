return {
    {
        "Mofiqul/dracula.nvim",
        config = function()
            require"dracula".setup {
                colors = {
                    menu = "none"
                },
                transparent_bg = true,
                italic_comment = true,
                show_end_of_buffer = true,
                overrides = function (_) return {} end
            }
            vim.cmd.colorscheme "dracula"

            -- Override the `Pmenu` highlight group for coq.nvim
            vim.cmd.highlight("Pmenu guifg=#969696 guibg=#2f3146")
        end,
        priority = 500,
    }
}

return {
    setup = function()
        -- Enable syntax highlighting options
        for _, opt in ipairs {
            "array_whitespace_error",
            "chan_whitespace_error",
            "extra_types",
            "space_tab_error",
            "trailing_whitespace_error",
            "operators",
            "functions",
            "function_parameters",
            "function_calls",
            "types",
            "fields",
            "build_constraints",
            "generate_tags",
            "format_strings",
            "variable_declarations",
            "variable_assignments",
        } do
            vim.g["go_highlight_"..opt] = true
        end

        -- Disable `vim-go` functionality that I don't use
        for _, opt in ipairs {
            "code_completion",
            "gopls",
        } do
            vim.g["go_"..opt.."_enabled"] = false
        end

        vim.g.go_fold_enable = {"block", "import"}

        -- Refresh syntax highlighting
        vim.cmd 'syntax on'
    end
}

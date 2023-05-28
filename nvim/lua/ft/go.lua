-- Enable syntax highlighting options
for _, opt in ipairs({
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
}) do
	vim.g["go_highlight_"..opt] = true
end

-- Refresh syntax highlighting
vim.cmd 'syntax on'

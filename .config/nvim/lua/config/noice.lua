local M = {}

function M.setup()
    require"noice".setup {
        cmdline = {
            view = "cmdline"
        },
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
        },
        popupmenu = {
            enabled = true,
            view = "popupmenu"
        },
        presets = {
            inc_rename = true,
            bottom_search = true,
            long_message_to_split = true,
            lsp_doc_border = true,
        },
    }
end

return M

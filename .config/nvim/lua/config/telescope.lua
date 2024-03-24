local M = {}

function M.setup()
    local telescope = require"telescope"
    telescope.setup {
        extensions = {
            ["ui-select"] = {
                require"telescope.themes".get_cursor {}
            }
        }
    }
    --[[for _, extension in ipairs({"file_browser", "ui-select", "projects"}) do
        telescope.load_extension(extension)
    end]]
end

return M

local M = {}


function M.setup()
    local lolcrab = vim.fn.executable("lolcrab") == 1
    local center = vim.iter(pairs(require"util.json"(vim.fn.stdpath("data").."/telescope_keys.json") or {})):map(
    ---@param picker string
    ---@param key string
    function(picker, key)
        return {
            desc = (" "..picker):gsub("_", " "):gsub(" ([a-z])", function(c) return " "..c:upper() end):sub(2),
            action = "Telescope "..picker,
            key = key,
        }
    end):totable()
    table.sort(center, function(a, b) return a.key < b.key end)



    require"dashboard".setup {
        theme = "doom",
        preview = lolcrab and {
            command = "lolcrab -g cool",
            file_path = vim.fn.stdpath("data").."/logo.txt",
            file_width = 69,
            file_height = 8,
        },
        config = {
            header = (not lolcrab) and vim.fn.readfile(vim.fn.stdpath("data").."/logo.txt"),
            center = center,
        }
    }
end

return M

local M = {}

local cargo = vim.fn.executable("cargo") == 1

function M.setup()
    require"dashboard".setup {
        theme = "doom",
        preview = cargo and {
            command = "lolcrab -g cool",
            file_path = vim.fn.stdpath("data").."/logo.txt",
            file_width = 69,
            file_height = 8,
        },
        config = {
            header = (not cargo) and vim.fn.readfile(vim.fn.stdpath("data").."/logo.txt"),
            center = vim.iter(pairs(require"util.json"(vim.fn.stdpath("data").."/telescope_keys.json") or {})):map(
            ---@param picker string
            ---@param key string
            function(picker, key)
                return {
                    desc = (" "..picker):gsub("_", " "):gsub(" ([a-z])", function(c) return " "..c:upper() end):sub(2),
                    action = "Telescope "..picker,
                    key = key,
                }
            end):totable()
        }
    }
end

return M

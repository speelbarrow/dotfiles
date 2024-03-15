---@param name string
---@return table
return function(name)
    -- Storage of `require` results to be returned.
    local r = {}

    --[[
    I can't imagine a scenario where I'd need to traverse past 5 layers, but I can always come back and update this if
    necessary.
    ]]

    for entry in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/" .. name, { depth = 5 }) do
        -- Only `require` when `entry` is a Lua file and isn't named "init.lua"

        local suffix = ".lua"
        local init = "init.lua"
        if entry:sub(-#suffix) == suffix and entry:sub(-#init) ~= init then
            table.insert(r, require((name .. "." .. entry:sub(1, #entry - #suffix)):gsub("/", ".")))
        end
    end

    return r
end

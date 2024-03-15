---@param name string
return function(name)
    --[[
    I can't imagine a scenario where I'd need to traverse past 5 layers, but I can always come back and update this if
    necessary.
    ]]

    for entry in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/" .. name, { depth = 5 }) do

        -- Only `require` when `entry` is a Lua file

        local suffix = ".lua"
        local init = "init.lua"
        if entry:sub(-#suffix) == suffix and entry:sub(-#init) ~= init then
            require((name .. "." .. entry:sub(1, #entry - #suffix)):gsub("/", "."))
        end
    end
end

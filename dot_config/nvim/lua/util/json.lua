local cache = {}

---@param path string Will be expanded using `vim.fn.fnamemodify`.
---@return table?
return function(path)
    path = vim.fn.fnamemodify(path, ":p")

    if cache[path] == nil then
        cache[path] = vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
    end
    return cache[path]
end

local M = {}

-- Key labels
local keylabels = {
    "Hover",
    "Rename",
    "Code Action",
    "Go to Definition",
    "Diagnostic",
    "Clear Highlight",
    "Copilot: Off"
}

function M.touchbar()
    for index = 1, 24 do
        vim.cmd("TouchBarLabel F"..index.." '"..(keylabels[index] or " ").."'")
    end
end

-- Helper function for updating Copilot key label
local function update_copilot_key()
    keylabels[#keylabels] = (vim.fn["copilot#Enabled"]() ~= 0) and "Copilot: On" or "Copilot: Off"
    vim.schedule(vim.fn["it2touchbar#RegenKeys"])
end

function M.setup()
    vim.cmd [[
    function! TouchBar() 
    lua require'setup.vim-it2-touchbar'.touchbar() 
    endfunction
    ]]

    vim.api.nvim_create_autocmd("BufEnter", { callback = update_copilot_key })

    vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
            update_copilot_key()
            vim.cmd.mode()

            vim.api.nvim_create_autocmd("User", {
                pattern = "CopilotToggled",
                callback = update_copilot_key
            })
        end
    })
end

return M

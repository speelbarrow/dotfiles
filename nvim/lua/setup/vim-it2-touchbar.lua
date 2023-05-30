local keymap = require'dotfiles.keymap'

local M = {}

vim.cmd [[
function! TouchBar() 
	lua require'dotfiles.setup.vim-it2-touchbar'.touchbar() 
endfunction
]]

function M.touchbar()
	for index = 1, 24 do
		vim.cmd("TouchBarLabel F"..index.." '"..(keymap.function_keys[index] or { "" })[1].."'")
	end
end

-- Listeners for LspAttach (first) and CopilotToggled (all) events to switch label text
vim.api.nvim_create_autocmd("User", {
	pattern = "CopilotToggled",
	callback = function()
		keymap.function_keys[#keymap.function_keys][1] = (vim.fn["copilot#Enabled"]() ~= 0) and "Copilot: On" or "Copilot: Off"
		vim.fn["it2touchbar#RegenKeys"]()
	end
})

return M
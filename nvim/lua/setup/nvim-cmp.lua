local cmp = require'cmp'
local helpers = require'dotfiles.cmp-vsnip-helpers'

-- Need to set these options or Copilot will complain that nvim-cmp is using the <Tab> keybind
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

cmp.setup {
	-- Tell nvim-cmp how to handle snippets
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end
	},

	-- Map keys
	mapping = {
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping.select_next_item(),
		["<Tab>"] = cmp.mapping(
		function()
			-- If the completion menu is open...
			if cmp.visible() then
				cmp.select_next_item()
			else if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
				vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](), "i", true)
				helpers.feedkey("<ESC><C-l>a", "n")

			-- If the completion menu is not open, there are no Copilot suggestions, but a snippet is available...
			elseif vim.fn["vsnip#available"](1) == 1 then
				helpers.feedkey("<Plug>(vsnip-expand-or-jump)<C-l>", "")

			-- Otherwise, just fallback to default
			else
				helpers.feedkey("<Tab>", "n")
			end
		end
	end,
	{ "i", "s" }
	),
	["<S-Tab>"] = cmp.mapping(
	function()
		-- If the completion menu is open, close it
		if cmp.visible() then
			cmp.close()

		-- If Copilot has a suggestion, dismiss it
		elseif vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
			vim.api.nvim_feedkeys(vim.fn["copilot#Dismiss"](), "i", true)

		-- Otherwise, just fallback to default
		else
			helpers.feedkey("<S-Tab>", "n")
		end
	end,
	{ "i", "s" }
	),
	['<CR>'] = cmp.mapping.confirm({ select = true }),
},


-- Tell nvim-cmp where it can get information from
sources = {
	{
		name = 'nvim_lsp',

		-- Filter out annoying 'Text' autofills
		entry_filter = function(entry, _)
			local kind = require'cmp.types'.lsp.CompletionItemKind[entry:get_kind()]
			return kind ~= "Text"
		end
	},
	{ name = 'vsnip' },
	-- { name = 'buffer' },	
},

-- Add the cute little icons into the box there
formatting = {
	format = function(_, vim_item)
		vim_item.kind = string.format('%s  %s', require'dotfiles.kind-icons'[vim_item.kind], vim_item.kind)
		return vim_item
	end
},
}

-- Draw autocompletions from the buffer for '/' (finding)
cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})

-- Draw autocompletions from path, buffer for vim command line (':')
cmp.setup.cmdline(':', {
	sources = {
		{ name = 'path' },
		{ name = 'cmdline' },
	}
})

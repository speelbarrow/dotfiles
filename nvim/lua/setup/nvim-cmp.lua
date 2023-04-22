local cmp = require'cmp'
--local cmp_ultisnips_mappings = require'cmp_nvim_ultisnips.mappings'

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
			function(fallback)
				local helpers = require'cmp-vsnip-helpers'

				-- If the completion menu is open...
				if cmp.visible() then
					-- If there are words before the cursor, complete
					if helpers.has_words_before() then
						cmp.complete()
					-- If there are no words before the cursor, select the next item
					else
						cmp.select_next_item()
					end

				-- If Copilot has a suggestion, accept it
				elseif vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
					vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](), "i", true)
					-- Clears the status line
					helpers.feedkey("<Esc><C-l>a", "n")

				-- If the completion menu is not open, there are no Copilot suggestions, but a snippet is available...
				elseif vim.fn["vsnip#available"](1) == 1 then
					helpers.feedkey("<Plug>(vsnip-expand-or-jump)<C-l>", "")

				-- Otherwise, just fallback to default
				else
					fallback()
				end

				--[[
				cmp_ultisnips_mappings.expand_or_jump_forwards(function()
					-- Map Copilot action along with everything else
					local copilot_keys = vim.fn["copilot#Accept"]()
					if copilot_keys ~= "" then
						vim.api.nvim_feedkeys(copilot_keys, "i", true)
					else
						fallback()
					end
				end)
				]]--
			end,
			{ "i", "s" }
		),
		["<S-Tab>"] = cmp.mapping(
			function(fallback)
				-- Map Copilot action along with everything else
				if cmp.visible() then
					cmp.close()
				else
					local copilot_keys = vim.fn["copilot#Dismiss"]()
					if copilot_keys ~= "" then
						vim.api.nvim_feedkeys(copilot_keys, "i", true)
					else
						fallback()
					end
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
		{ name = 'ultisnips' },
		-- { name = 'buffer' },	
	},

	-- Add the cute little icons into the box there
	formatting = {
		format = function(_, vim_item)
			vim_item.kind = string.format('%s  %s', require'kind-icons'[vim_item.kind], vim_item.kind)
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

-- Get out of the way of Copilot
cmp.event:on("menu_opened", function()
	vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
	vim.b.copilot_suggestion_hidden = false
end)

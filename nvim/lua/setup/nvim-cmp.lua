---@param keys string
---@param mode string?
local function feedkeys(keys, mode)
    mode = mode or 'n'
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, false)
end

local kind_icons = {
  Text = "󱩾",
  Method = "󱝒",
  Function = "󰒓",
  Constructor = "󱉜",
  Field = "󱝔",
  Variable = "󰏫",
  Class = "󰀼",
  Interface = "󰠥",
  Module = "󰏖",
  Property = "󰓹",
  Unit = "",
  Value = "󰎠",
  Enum = "󰖽",
  Keyword = "",
  Snippet = "󰲋",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰝰",
  EnumMember = "󰈍",
  Constant = "󰏿",
  Struct = "󰉺",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

return {
    setup = function()
        local cmp = require'cmp'

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
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            -- Map keys
            mapping = {
                ["<Up>"] = cmp.mapping.select_prev_item(),
                ["<Down>"] = cmp.mapping.select_next_item(),
                ["<ScrollWheelUp>"] = cmp.mapping.select_prev_item(),
                ["<ScrollWheelDown>"] = cmp.mapping.select_next_item(),
                ["<S-Up>"] = cmp.mapping.scroll_docs(-1),
                ["<S-Down>"] = cmp.mapping.scroll_docs(1),
                ["<S-ScrollWheelUp>"] = cmp.mapping.scroll_docs(-1),
                ["<S-ScrollWheelDown>"] = cmp.mapping.scroll_docs(1),
                ["<Tab>"] = cmp.mapping(function()
                    -- If the completion menu is open, select the next item
                    if cmp.visible() then
                        cmp.select_next_item()

                        -- If copilot has a suggestion, accept it
                    elseif vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
                        vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](), "i", true)
                        feedkeys("<ESC><C-l>a")

                        -- Otherwise, just fallback to default
                    else
                        feedkeys("<Tab>")
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function()
                    -- If the completion menu is open, close it
                    if cmp.visible() then
                        cmp.close()

                        -- If Copilot has a suggestion, dismiss it
                    elseif vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
                        vim.api.nvim_feedkeys(vim.fn["copilot#Dismiss"](), "i", true)

                        -- Otherwise, just fallback to default
                    else feedkeys("<S-Tab>") end
                end, { "i", "s" }),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            },


            -- Tell nvim-cmp where it can get information from
            sources = {
                { name = 'nvim_lsp' },
                { name = 'vsnip' },
                -- { name = 'buffer' },
            },

            -- Add the cute little icons into the box there
            formatting = {
                format = function(_, vim_item)
                    vim_item.kind = string.format('%s  %s', kind_icons[vim_item.kind], vim_item.kind)
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
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'path' },
                { name = 'cmdline', option = { ignore_cmds = { "Man" } } },
            }
        })
    end
}

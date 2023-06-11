return {
    setup = function()
        require'lualine'.setup {
            options = {
                theme = 'dracula',
                globalstatus = true,
                section_separators = { left = ' ', right = '  ' },
            },
            sections = {
                lualine_a = {
                    'mode'
                },
                lualine_b = {
                    'branch',
                    {
                        'diff',
                        colored = false,
                        source = function()
                            local status_dict = vim.b['gitsigns_status_dict']
                            if status_dict == nil then
                                return nil
                            end
                            return {
                                added = status_dict.added,
                                modified = status_dict.changed,
                                removed = status_dict.removed,
                            }
                        end
                    },
                },
                lualine_c = {
                    {
                        'buffers',
                    }
                },
                lualine_x = {
                    function() return vim.fn["copilot#Enabled"]() == 0 and ' ' or ' ' end,
                    'encoding',
                    {
                        'fileformat',
                        symbols = {
                            dos = '󰨡',
                            mac = '󰀶',
                            unix = '󰌽',
                        }
                    },
                    'filetype'
                },
                lualine_y = {
                    {
                        'diagnostics',
                        sources = { 'nvim_lsp' },
                        sections = { 'error', 'warn', 'info', 'hint' },
                        symbols = {
                            error = '󰜺 ',
                            warn = '󰀦 ',
                            info = '󰋼 ',
                            hint = '󰌵 ',
                        },
                        update_in_insert = true,
                    }
                },
                lualine_z = { 'location' },
            },
        }

        vim.cmd "highlight link lualine_c_buffers_active lualine_transitional_lualine_a_normal_to_lualine_c_normal"
    end
}

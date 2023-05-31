vim.g.dracula_full_special_attrs_support = true
vim.g.dracula_colorterm = 0
vim.cmd.colorscheme 'dracula'

-- Set up some custom highlighting for NvimTree (because it doesn't link to Dracula automatically)
vim.cmd [[
hi! link NvimTreeGitDeleted DiffDelete
hi! link NvimTreeGitIgnored DraculaComment
hi! link NvimTreeExecFile DraculaRed
hi! link NvimTreeSpecialFile DraculaFgBold
hi! link NvimTreeGitDirty DiffChange
hi! link NvimTreeGitMerge DraculaPurple
hi! link NvimTreeGitNew DraculaYellow
hi! link NvimTreeGitStaged DiffAdd
hi! link NvimTreeGitRenamed DraculaInfoLine
hi! link NvimTreeOpenedFile DraculaPink
]]

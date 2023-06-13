return {
    setup = function()
        require 'project_nvim'.setup {
            ignore_lsp = {
                'copilot',
                'lua_ls'
            }
        }

        require'telescope'.load_extension "projects"
    end
}

-- Download 'lazy.nvim' if necessary, make its files available
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:append(lazypath)

-- Plugin configurations
require 'lazy'.setup {
	install = { colorscheme = { 'dracula' } },
    performance = { rtp = { paths = (function()
        local path = vim.fn.fnamemodify(vim.fn.resolve(vim.env.MYVIMRC), ':h')
        return { path, path.."/after" }
    end)() } },
	spec = {
		-- Dracula theme
        {
            'Mofiqul/dracula.nvim',
            config = function() require'setup.dracula'.setup() end,

            priority = 1000,
        },


		--                         --
		-- PROJECT/FILE MANAGEMENT --
		--                         --

		-- Tree view
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
                {
                    "miversen33/netman.nvim",
                    cond = vim.fn.executable("docker") == 1 and vim.fn.executable("ssh") == 1 and
                            vim.fn.executable("sftp") == 1,
                }
            },
            config = function() require'setup.neo-tree'.setup() end,
        },

        -- Git integration
        {
            'tpope/vim-fugitive',

            -- Disable maps by default
            init = function() vim.g.fugitive_no_maps = 1 end,
        },

		-- Project detection
		{
			'ahmedkhalf/project.nvim',
			config = function() require'setup.project_nvim'.setup() end,
		},

		-- Git diff line indicators
		{
			'lewis6991/gitsigns.nvim',
			config = require'setup.gitsigns'.setup,
		},


		-- 	  	             --
		-- EXECUTION/TESTING --
		-- 	  	             --

		-- Dispatch executions and tests asynchronously
		{
			'tpope/vim-dispatch',
            config = function() require'setup.dispatch'.setup() end,
		},

		-- Preview Markdown files
		{
			'iamcco/markdown-preview.nvim',
			ft = 'markdown',
			lazy = true,
			build = ":call mkdp#util#install()"
		},

		-- 	  	     	   --
		-- QUALITY OF LIFE --
		-- 	  			   --

		-- Cute little status line thing
		{
			'nvim-lualine/lualine.nvim',
            dependencies = {
                'nvim-tree/nvim-web-devicons',
            },
			config = function() require'setup.lualine'.setup() end,
		},

		-- Macbook Touch Bar integration
		{
			'speelbarrow/vim-it2-touchbar',
			branch = 'migrate-writefile',

			-- Only load when in iTerm2
			cond = vim.env.ITERM_SESSION_ID ~= nil,

			-- Set up the touchbar labels/actions
			config = function() require'setup.vim-it2-touchbar'.setup() end,
            priority = 1000,
		},

		-- Automatically close HTML/XML tags
		{
			'alvan/vim-closetag',
			ft = { 'html', 'xml', 'gohtmltmpl', 'svg' },
			init = function() vim.g.closetag_filenames = '*.html,*.xml,*.gohtml,*.svg' end,
        },

		-- Close buffers better
		'famiu/bufdelete.nvim',

        -- Customizable startup screen
        {
            'startup-nvim/startup.nvim',
            dependencies = {
                "nvim-telescope/telescope.nvim",
            },
            event = "VimEnter",
            config = function() require'setup.startup'.setup() end,
        },

        -- Quicksearch anything
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                "nvim-telescope/telescope-ui-select.nvim",
                "nvim-lua/plenary.nvim",
            },
            lazy = true,
        },

        -- Auto pairs
        'LunarWatcher/auto-pairs',

		--				                          --
		-- LANGUAGE SERVERS & SYNTAX HIGHLIGHTING --
		--				                          --

		-- GitHub Copilot
		{
			'github/copilot.vim',
			config = function() require'setup.copilot'.setup() end
		},

		-- LSP configs
		{
			'neovim/nvim-lspconfig',
			config = function() require'setup.lspconfig'.setup() end,
		},

		-- Provides autocompletion
		{
			'hrsh7th/nvim-cmp',
			dependencies = {
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-cmdline',

				-- Snippet engine
				'hrsh7th/vim-vsnip',

				-- Acutal snippets
				'rafamadriz/friendly-snippets',
			},

			lazy = true,
			event = "LspAttach",

			-- Run config on load
			config = function() require'setup.nvim-cmp'.setup() end,

			-- Load early
			priority = 500,
		},

		-- Hacks LuaLS and provides syntax awareness for Neovim libraries when editing Neovim configuration files
		'folke/neodev.nvim',

		-- Rust LSP and other goodies
		{
			'speelbarrow/rust-tools.nvim',
			ft = 'rust',
			dependencies = {
				-- Better syntax highlighting
				'rust-lang/rust.vim',

                -- Crate version resolution
                'Saecki/crates.nvim',
			},
			config = function() require'setup.rust-tools'.setup() end,
		},

		-- Not exactly a language server but close enough, provides better experience in Cargo.toml files
		{
			'Saecki/crates.nvim',
			dependencies = {
				'nvim-lua/plenary.nvim',

                -- Rust LSP and other goodies
                'speelbarrow/rust-tools.nvim'
			},
			event = "BufRead Cargo.toml",
			config = function() require'setup.crates'.setup() end,
		},

        -- Provides schema files for JSON and YAML
        {
            'b0o/SchemaStore.nvim',
            lazy = true
        },

		-- Provides syntax highlighting for go.mod and Go template files (amongst other things)
		{
			'fatih/vim-go',
			ft = { 'go', 'gohtmltmpl', 'gomod' },
            build = ":GoUpdateBinaries",
            config = function() require'setup.vim-go'.setup() end,
		},

        -- Better highlighting for GNU Assembler files
        {
            "shirk/vim-gas",
            ft = "asm,gas",
        },

        -- Syntax highlighting for Kitty configuration files
        {
            'fladson/vim-kitty',
            ft = 'kitty',
        },

        -- Syntax highlighting for Rhai scripting language
        {
            'rhaiscript/vim-rhai',
            ft = 'rhai',
        },

        -- Syntax and indents for Swift
        {
            'keith/swift.vim',
            ft = 'swift',
        },

        --       --
        -- LOCAL --
        --       --
        (function()
            if vim.fn.filereadable(vim.fn.fnamemodify(vim.env.MYVIMRC, ":h").."/lua/local/lazy.lua") == 1 then
                return unpack(require'local.lazy')
            end
        end)()
	}
}

require 'rust-tools'.setup({
	server = {
		standalone = true,
	},
    settings = {
        ["rust-analyzer"] = {
            cachePriming = {
                -- Can be set per system or falls back to default
                numThreads = vim.g.rust_analyzer_num_threads or 0,
            },
            numThreads = vim.g.rust_analyzer_num_threads or 0,
            procMacro = {
                enable = true
            },
        }
    }
})

-- Disable recommended styles provided by rust.vim
vim.g.rust_recommended_style = 0

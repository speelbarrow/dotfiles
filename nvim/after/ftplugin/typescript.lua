require'setup.dispatch'.configure_buffer({
    compiler = "bun",
    run = function() vim.cmd("Start -wait=always bun run %") end,
    test = true,
    build = true,
})

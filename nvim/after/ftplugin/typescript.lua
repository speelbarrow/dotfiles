require'setup.dispatch'.configure_buffer({
    compiler = "bun",
    run = function()
        if vim.fn.filereadable("./package.json") == 1 then
            vim.cmd("Start -wait=always bun start")
        else
            vim.cmd("Start -wait=always bun run %")
        end
    end,
    test = true,
    build = true,
})

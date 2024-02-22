require'setup.dispatch'.configure_buffer {
    compiler = "swift",
    run = {
        cmd = true,
        interactive = true,
        persist = true,
    },
    debug = {
        cmd = "run --debugger",
        interactive = true,
    },
    test = true,
    build = true,
}

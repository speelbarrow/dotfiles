require'setup.dispatch'.configure_buffer {
    compiler = "swift",
    run = {
        true,
        interactive = true,
        persist = true,
    },
    debug = {
        "run --debugger",
        interactive = true,
    },
    test = true,
    build = true,
}

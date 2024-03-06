vim.bo.textwidth = 79

require'setup.dispatch'.configure_buffer {
    compiler = "python3",
    run = {
        cmd = "%",
        interactive = true,
        persist = true,
    },
    debug = {
        cmd = "python3 -m pdb %",
        interactive = true,
    },
}

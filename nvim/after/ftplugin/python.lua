require'setup.dispatch'.configure_buffer {
    run = function() vim.cmd "Start -wait=always python3 %" end,
    debug = "python3 -m pdb %",
}

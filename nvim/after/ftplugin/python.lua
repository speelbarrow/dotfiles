vim.bo.textwidth = 79

require'setup.dispatch'.configure_buffer {
    run = function() vim.cmd "Start -wait=always python3 %" end,
    debug = function() vim.cmd "Start python3 -m pdb %" end,
}

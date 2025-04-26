# TODO: Make this better
{ ... }: {
  "after/ftplugin/markdown.lua".text = ''
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.tabstop = 2
  '';
  "after/ftplugin/nix.lua".text = ''
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.tabstop = 2
  '';
  "after/ftplugin/bindzone.lua".text = ''
    vim.o.shiftwidth = 8
    vim.o.softtabstop = 8
    vim.o.tabstop = 8
  '';
  "after/ftplugin/sh.lua".text = ''
    vim.o.shiftwidth = 8
    vim.o.softtabstop = 8
    vim.o.tabstop = 8
  '';
}

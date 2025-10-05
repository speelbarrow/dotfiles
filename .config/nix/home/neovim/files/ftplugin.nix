# TODO: Make this better
{ ... }: let
  javascript = {
    text = ''
      vim.o.shiftwidth = 2
      vim.o.softtabstop = 2
      vim.o.tabstop = 2
    '';
  };
in {
  "after/ftplugin/arduino.lua".text = ''
    vim.o.shiftwidth = 4
    vim.o.softtabstop = 4
    vim.o.tabstop = 4
    vim.o.textwidth = 120
  '';
  "after/ftplugin/asm.lua".text = ''
    vim.o.shiftwidth = 8
    vim.o.softtabstop = 8
    vim.o.tabstop = 8
  '';
  "after/ftplugin/c.lua".text = "vim.o.textwidth = 120";
  "after/ftplugin/cmake.lua".text = ''
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.tabstop = 2
  '';
  "after/ftplugin/cpp.lua".text = "vim.o.textwidth = 120";
  "after/ftplugin/css.lua".text = ''
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.tabstop = 2
  '';
  "after/ftplugin/html.lua".text = ''
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.tabstop = 2
  '';
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
  "after/ftplugin/lua.lua".text = ''
    vim.o.shiftwidth=2
    vim.o.softtabstop=2
    vim.o.tabstop=2
  '';
  "after/ftplugin/javascript.lua" = javascript;
  "after/ftplugin/sh.lua".text = ''
    vim.o.shiftwidth = 8
    vim.o.softtabstop = 8
    vim.o.tabstop = 8
  '';
  "after/ftplugin/sql.lua".text = ''
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.tabstop = 2
  '';
  "after/ftplugin/toml.lua".text = ''
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
    vim.o.tabstop = 2
  '';
  "after/ftplugin/typescript.lua" = javascript;
}

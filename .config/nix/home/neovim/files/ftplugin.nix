# TODO: Make this better
{ ... }: let
  make = offset: ''
    vim.o.shiftwidth = ${offset}
    vim.o.softtabstop = ${offset}
    vim.o.tabstop = ${offset}
  '';
  two = make "2";
  four = make "4";
  eight = make "8";
in {
  "after/ftplugin/arduino.lua".text = four + ''
    vim.bo.textwidth = 120
  '';
  "after/ftplugin/asm.lua".text = eight;
  "after/ftplugin/c.lua".text = "vim.o.textwidth = 120";
  "after/ftplugin/cmake.lua".text = two;
  "after/ftplugin/cpp.lua".text = "vim.o.textwidth = 120";
  "after/ftplugin/cs.lua".text = four;
  "after/ftplugin/css.lua".text = two; 
  "after/ftplugin/cucumber.lua".text = two;
  "after/ftplugin/glsl.lua".text = four;
  "after/ftplugin/html.lua".text = two;
  "after/ftplugin/markdown.lua".text = two;
  "after/ftplugin/nix.lua".text = two;
  "after/ftplugin/bindzone.lua".text = eight;
  "after/ftplugin/lua.lua".text = two;
  "after/ftplugin/javascript.lua".text = two;
  "after/ftplugin/json.lua".text = two;
  "after/ftplugin/sh.lua".text = eight;
  "after/ftplugin/sql.lua".text = two;
  "after/ftplugin/toml.lua".text = two;
  "after/ftplugin/typescript.lua".text = two;
  "after/ftplugin/typst.lua".text = two + ''
    vim.o.spell = true
    vim.bo.textwidth = 0
  '';
}

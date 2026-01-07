{ lib, pkgs, ... }: let
in lib.mkIf pkgs.stdenv.isDarwin {
  programs.ghostty.settings = {
    font-thicken = true;
    background-blur-radius = 50;
    window-colorspace = "display-p3";
    macos-titlebar-style = "transparent";
    macos-option-as-alt = true;
    macos-icon = "custom-style";
    macos-icon-frame = "plastic";
    macos-icon-ghost-color = "green";
    macos-icon-screen-color = "red";
  };
  programs.ghostty.package = pkgs.ghostty-bin; 
  programs.zsh.shellAliases.python = "python3";
}

{ lib, pkgs, ... }: {
  home.packages = [pkgs.radare2]; 
  programs.zsh.initContent = lib.mkMerge [(lib.mkOrder 1000 (builtins.readFile ./r2.zsh))];
}

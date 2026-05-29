{ pkgs, ... }:
{
  home.packages = [ pkgs.vesktop ];
  programs.nixvim.plugins.cord = {
    enable = true;
  };
}

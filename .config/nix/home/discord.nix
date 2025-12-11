{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
  ];
  programs.nixvim.plugins.cord.enable = true;
}

{ lib, pkgs, ... }: lib.optionalAttrs (builtins.pathExists "/etc/nixos/configuration.nix") {
  environment.systemPackages = with pkgs; [ 
    docker
  ];
  services = {
    xserver = {
      desktopManager.pantheon.enable = true;
      enable = true;
    };
  };
}

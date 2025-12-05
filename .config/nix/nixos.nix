{ lib, pkgs, ... }: lib.optionalAttrs (builtins.pathExists "/etc/nixos/configuration.nix") {
  environment.systemPackages = with pkgs; [ 
    docker
  ];
  services = {
    desktopManager.pantheon.enable = true;
    xserver = {
      enable = true;
    };
  };
}

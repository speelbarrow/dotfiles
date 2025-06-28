{ lib, ... }: lib.mkIf (builtins.pathExists "/etc/nixos/configuration.nix") {
  services = {
    xserver = {
      desktopManager.pantheon.enable = true;
      enable = true;
    };
  };
}

{ lib, ... }: lib.optionalAttrs (builtins.pathExists "/etc/nixos/configuration.nix") {
  services = {
    xserver = {
      desktopManager.pantheon.enable = true;
      enable = true;
    };
  };
  virtualisation.rosetta.enable = true;
}

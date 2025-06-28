{ lib, pkgs, ... }: lib.mkIf (builtins.pathExists "/etc/nixos/configuration.nix") {
  fileSystems = {} // lib.optionalAttrs pkgs.stdenv.isAarch64 {
    "/rosetta" = {
      device = "rosetta";
      fsType = "virtiofs";
      noCheck = true;
      options = [
        "ro"
        "nofail"
      ];
    };
  };
  services = {
    xserver = {
      desktopManager.pantheon.enable = true;
      enable = true;
    };
  };
}

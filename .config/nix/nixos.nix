{ lib, pkgs, ... }: let
  isNixos = builtins.pathExists "/etc/nixos/configuration.nix";
in lib.optionalAttrs isNixos ({
  services = {
    xserver = {
      desktopManager.pantheon.enable = true;
      enable = true;
    };
  };
} // (lib.optionalAttrs (isNixos && pkgs.stdenv.isAarch64) {
  fileSystems = {
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
}))

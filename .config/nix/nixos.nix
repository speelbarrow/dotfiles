{ lib, ... }: lib.optionalAttrs (builtins.pathExists "/etc/nixos/configuration.nix") {
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
  services = {
    xserver = {
      desktopManager.pantheon.enable = true;
      enable = true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
import ../mkDir.nix {
  args = { inherit config lib pkgs; };
  extra = [
    {
      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "pnpm-10.29.2" ];
      };
    }
  ];
  inherit lib;
  path = ./.;
}

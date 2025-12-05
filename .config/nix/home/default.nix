{ config, lib, pkgs, ... }: import ../mkDir.nix {
  args = { inherit config lib pkgs; };
  extra = [
    { nixpkgs.config.allowUnfree = true; }
  ];
  inherit lib;
  path = ./.;
}

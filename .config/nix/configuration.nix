{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
in
import ./mkDir.nix {
  args = {
    inherit config lib pkgs;
    isDarwin = lib.hasSuffix "darwin" builtins.currentSystem;
  };
  extra = [
    {
      nixpkgs.config.allowUnfree = true;
    }
    (
      if builtins.pathExists "/etc/nixos/configuration.nix" then
        ((import /etc/nixos/configuration.nix) {
          inherit
            config
            lib
            modulesPath
            pkgs
            ;
        })
      else
        { }
    )
  ];
  filter = [
    "configuration.nix"
    "home"
    "mkDir.nix"
    "shell"
    "user.nix"
    "version.nix"
  ];
  inherit lib;
  path = ./.;
}

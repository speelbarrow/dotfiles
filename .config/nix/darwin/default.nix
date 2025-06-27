{ lib, isDarwin, pkgs, ... }: let
  casks = import ./casks.nix pkgs;
in lib.mkIf isDarwin ({
  environment = with pkgs; {
    systemPackages = [
      casks.docker-desktop
      casks.onyx
      darwin.libiconv
      google-chrome
      imagemagick # required for folderify
      raycast
      (rustPlatform.buildRustPackage rec {
        pname = "folderify";
        version = "v4.1.0";
        cargoHash = "sha256-ifeJgv9fAXbEzVsH258/9BVue9Po8CkwrtyhkcGbDs4=";
        src = fetchFromGitHub {
          owner = "lgarron";
          repo = pname;
          rev = version;
          sha256 = "eunyn8uUL77J6xnt/2iofT4+qRmkP8eNGx/4DsDh6u0=";
        };
      })
      tun2proxy
    ];
    variables.LIBRARY_PATH = "${darwin.libiconv}/lib";
  };
  nixpkgs.overlays = [
    (final: prev: with casks; { inherit ghostty neovide; })
  ];
  security.pam.services.sudo_local.touchIdAuth = true;
} // lib.optionalAttrs isDarwin {
  system.primaryUser = "speelbarrow";
})

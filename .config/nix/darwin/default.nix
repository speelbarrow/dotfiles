{ lib, isDarwin, pkgs, ... }: let
  casks = import ./casks.nix pkgs;
in lib.mkIf isDarwin {
  environment = with pkgs; {
    systemPackages = [
      casks.docker
      casks.onyx
      darwin.libiconv
      imagemagick # required for folderify
      raycast
      (rustPlatform.buildRustPackage rec {
        pname = "folderify";
        version = "v4.0.1";
        cargoHash = "sha256-gFC8AII65hQlQtwhMQhAN9PekclgF0gPU5ASe046NYc=";
        src = fetchFromGitHub {
          owner = "lgarron";
          repo = pname;
          rev = version;
          hash = "sha256-syhnX1volDBPcvwuqDkDLavrI3znjwlT4SXFq//OLdY=";
        };
      })
    ];
    variables.LIBRARY_PATH = "${darwin.libiconv}/lib";
  };
  nixpkgs.overlays = [
    (final: prev: with casks; { inherit ghostty neovide; })
  ];
  security.pam.services.sudo_local.touchIdAuth = true;
}

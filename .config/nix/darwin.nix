{ lib, isDarwin, pkgs, ... }: lib.mkIf isDarwin ({
  environment = with pkgs; {
    interactiveShellInit = ''
      command -v container >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        container system start >/dev/null &>/dev/null
      fi
    '';
    systemPackages = [
      darwin.libiconv
      google-chrome
      imagemagick # required for folderify
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
      terminal-notifier
      tun2proxy
      utm
    ];
    variables.LIBRARY_PATH = "${darwin.libiconv}/lib";
  };
  nixpkgs.overlays = [(final: prev: with pkgs; {
    godot = let
      version = "4.6";
      flavour = "stable";
      fullVersion = "${version}-${flavour}";
      name = "Godot_v${fullVersion}_macos.universal.zip";
    in stdenv.mkDerivation {
        inherit (prev.godot) pname;
        version = fullVersion;

        src = fetchurl {
          inherit name;
          url = "https://downloads.godotengine.org/?version=${version}&flavor=${flavour}&slug=macos.universal.zip&platform=macos.universal";
          hash = "sha256-/BXOtigEIPEXq072IzJlTbAIgHj67rkCXdgUJ2GF7Ts=";
        };
        man = null;
        nativeBuildInputs = [ unzip ];
        sourceRoot = ".";
        installPhase = ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -R Godot.app $out/Applications
        runHook postInstall
        '';

        meta = prev.godot.meta // {
          platforms = lib.platforms.darwin;
        };
      };

    /*
godot = ((callPackage ((fetchFromGitHub {
owner = "NixOS";
repo = "nixpkgs";
rev = "46d304577ab3fbb7a0242bca9824045aa8bb51fe";
hash = "sha256-QecVtt9hWjJ74wn+Rzsk1Az8MTuk1GBBRyRCgMv6b/w=";
sparseCheckout = ["pkgs/development/tools/godot"];
}).outPath + "/pkgs/development/tools/godot")) {}).godot_4_5;
*/
  })];
  security.pam.services.sudo_local.touchIdAuth = true;
} // lib.optionalAttrs isDarwin {
    system.primaryUser = "speelbarrow";
  })

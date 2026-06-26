{
  lib,
  isDarwin,
  pkgs,
  ...
}:
lib.mkIf isDarwin (
  {
    environment = with pkgs; {
      interactiveShellInit = ''
        command -v container >/dev/null 2>&1
        if [ $? -eq 0 ]; then
          container system start >/dev/null &>/dev/null
        fi
      '';
      shellAliases = {
        notify-done = "terminal-notifier -sound default -message Done";
      };
      systemPackages = [
        blueutil
        darwin.libiconv
        google-chrome
        imagemagick # required for folderify
        (rustPlatform.buildRustPackage rec {
          pname = "folderify";
          version = "v4.1.3";
          cargoHash = "sha256-XyNcWwqy4w+b/epvjx6Jt7IBoZgxfowLOWeC6pMvaVo=";
          src = fetchFromGitHub {
            owner = "lgarron";
            repo = pname;
            rev = version;
            hash = "sha256-Gq6rXqvvnFmAzKxnoJ70x2zLA4h/P0hjMMldNMc6jtI=";
          };
        })
        terminal-notifier
        tun2proxy
        utm
      ];
      variables.LIBRARY_PATH = "${darwin.libiconv}/lib";
    };
    security.pam.services.sudo_local.touchIdAuth = true;

    nixpkgs.overlays = [
      (self: super: {
        godot =
          with pkgs;
          stdenv.mkDerivation rec {
            inherit (super.godot)
              man
              meta
              name
              version
              ;
            src = fetchurl {
              url = "https://godot-releases.nbg1.your-objectstorage.com/${version}/Godot_v${version}_macos.universal.zip";
              hash = "sha256-MGMPPpsR4Qs1wfkLqIFBhdzsQ/rhpINFFZvnVSxkv+g=";
            };
            nativeBuildInputs = [ unzip ];
            sourceRoot = ".";
            installPhase = ''
              runHook preInstall
              mkdir -p $out/Applications
              cp -R Godot.app $out/Applications
              runHook postInstall
            '';
          };
      })
    ];
  }
  // lib.optionalAttrs isDarwin {
    system.primaryUser = "speelbarrow";
  }
)

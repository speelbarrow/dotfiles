{ config, lib, isDarwin, pkgs, ... }: let
  casks = import ./casks.nix pkgs;
in lib.mkIf isDarwin ({
  environment = with pkgs; {
    interactiveShellInit = ''
      command -v container >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        container system start >/dev/null &>/dev/null
      fi
    '';
    systemPackages = [
        # casks.onyx
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
      utm
      xquartz
    ];
    variables.LIBRARY_PATH = "${darwin.libiconv}/lib";
  };
  security.pam.services.sudo_local.touchIdAuth = true;
} // lib.optionalAttrs isDarwin {
  system = {
    primaryUser = "speelbarrow";
    activationScripts.applications.text = let
      source = "${config.system.build.applications}/Applications/";
      destination = "/Applications/Nix";
    in ''
      echo "Copying .app bundles to ${destination}" >&2
      mkdir -p "${destination}"
      ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete \
        "${source}" "${destination}"
    '';
  };
})

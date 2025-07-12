{ config, lib, pkgs, ... }: let
  casks = import ../darwin/casks.nix pkgs;
in lib.mkIf pkgs.stdenv.isDarwin {
  home.activation.apps = let
    source = "$genProfilePath/home-path/Applications/";
    destination = "./Applications/Nix";
  in lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Copying .app bundles to ${destination}" >&2
      mkdir -p "${destination}"
      ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete \
        "${source}" "${destination}"
  '';
  programs.ghostty.settings = {
    font-thicken = true;
    background-blur-radius = 50;
    window-colorspace = "display-p3";
    macos-titlebar-style = "transparent";
    macos-option-as-alt = true;
    macos-icon = "custom-style";
    macos-icon-frame = "plastic";
    macos-icon-ghost-color = "green";
    macos-icon-screen-color = "red";
  };
  programs.ghostty.package = casks.ghostty // {
    meta.mainProgram = "ghostty";
  };
  programs.neovide.package = casks.neovide-app;
  programs.zsh.shellAliases.python = "python3";
}

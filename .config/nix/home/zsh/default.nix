{ lib, pkgs, ... }:
{
  programs.zsh =
    let
      init =
        path:
        lib.concatLines (
          import ../../mkDir.nix {
            inherit lib path;
          }
        );
    in
    {
      enable = true;

      autosuggestion.enable = true;
      autocd = true;
      defaultKeymap = "emacs";

      envExtra = ''
        if [ -d "$HOME/.config/zsh/env" ]; then
          for F in $HOME/.config/zsh/env/*; do
            . $F
          done
        fi
      '';

      history.share = true;
      historySubstringSearch.enable = true;

      localVariables =
        with lib;
        mkMerge [
          {
            DRACULA_ARROW_ICON = "-> ";
            DRACULA_DISPLAY_CONTEXT = 1;
            DRACULA_DISPLAY_FULL_CWD = 1;
            DRACULA_DISPLAY_TIME = 1;
            DRACULA_TIME_FORMAT = "%-I:%M:%S %p";
            ZSH_THEME = "dracula";
          }
          (mkIf pkgs.stdenv.isLinux { DEBIAN_PREVENT_KEYBOARD_CHANGES = "yes"; })
        ];

      initContent = lib.mkMerge [
        (lib.mkOrder 550 (init ./before))
        (lib.mkOrder 1000 (init ./after))
      ];

      plugins = with pkgs; [
        {
          name = "zsh-autoswitch-virtualenv";
          file = "autoswitch_virtualenv.plugin.zsh";
          src = fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-autoswitch-virtualenv";
            rev = "3.9.0";
            hash = "sha256-j2YX+OcYbvS2G/KUNzcWbJepm9bZlegp1r8ZjcY6Nnw=";
          };
        }
        {
          name = "dracula";
          file = "dracula.zsh-theme";
          src = fetchFromGitHub {
            owner = "dracula";
            repo = "zsh";
            rev = "a3e27d47ea2ed1e3b435f44aa71caf71d3219af6";
            hash = "sha256-unPUH3D89gH0j8/kv1Dl+ybR5n8UX0hJ+SuETtgpJOo=";
          };
        }
      ];

      syntaxHighlighting.enable = true;
    };
}

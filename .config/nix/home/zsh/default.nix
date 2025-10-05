{ lib, pkgs, ... }: {
  programs.zsh = let
    init = path: lib.concatLines (import ../../mkDir.nix {
      inherit lib path;
    });
  in {
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

    localVariables = with lib; mkMerge [
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

    plugins = [
      {
        name = "zsh-autoswitch-virtualenv";
        file = "autoswitch_virtualenv.plugin.zsh";
        src = builtins.fetchTarball {
          url = "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv/archive/master.tar.gz";
        };
      }
      {
        name = "dracula";
        file = "dracula.zsh-theme";
        src = builtins.fetchTarball {
          url = "https://github.com/speelbarrow/dracula-zsh/archive/master.tar.gz";
        };
      }
    ];

    syntaxHighlighting.enable = true;
  };
}

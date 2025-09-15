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
        DRACULA_DISPLAY_CONTEXT = 1;
        DRACULA_DISPLAY_FULL_CWD = 1;
        DRACULA_ARROW_ICON = "-> ";
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
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
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

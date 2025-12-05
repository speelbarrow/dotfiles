{ config, lib, pkgs, ... }: let 
  mkDir = args: (import ../../mkDir.nix (args // { inherit lib; }));
in {
  imports = let
    nixvim = import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      ref = "nixos-${import ../../version.nix}";
    });
  in [nixvim.homeModules.nixvim];
  
  programs.nixvim = let
    plugins = import ./plugins { inherit config lib pkgs; };
  in lib.mkMerge [
    (import ./spLauncher { inherit config lib pkgs; })
    {
      enable = true;
      nixpkgs = { inherit pkgs; };
      defaultEditor = true;
      vimAlias = true;

      colorschemes.dracula-nvim = {
        enable = true;
        lazyLoad.enable = true;
        settings = {
          colors.menu = "none";
          transparent_bg = false;
          italic_comment = true;
          show_end_of_buffer = true;
        };
      };

      dependencies.gcc.enable = false;
      
      luaLoader.enable = true;

      globals.health.style = "float";
      opts = {
        colorcolumn = "+1";
        expandtab = true;
        mouse = "a";
        number = true;
        # scrolloff = 20;
        shell = "zsh --login"; # required to get all the sourcings just right
        shiftwidth = 4;
        showmode = false;
        signcolumn = "no"; # gitsigns will still change the color of the numbers
        softtabstop = 4;
        splitbelow = true;
        splitright = true;
        tabstop = 4;
        textwidth = 100;
      };

      autoCmd = (mkDir {
        path = ./autocmd;
      });

      extraFiles = (mkDir {
        args = { inherit pkgs; };
        path = ./files;
      });

      extraPlugins = plugins.imports;

      filetype = (mkDir {
        path = ./filetype;
      });

      keymaps = (mkDir {
        args = {
          inherit lib;
          modifier = if pkgs.stdenv.isDarwin then "D" else "C";
          mode = ["n" "i" "v" "t" "c"];
        };
        path = ./keymaps;
      });

      plugins = plugins.config;

      userCommands = (mkDir {
        path = ./user;
      });
    }
  ];

  programs.neovide = {
    enable = true;
    settings = ({
      font = let
        family = "JetBrainsMono Nerd Font";
      in {
        size = if pkgs.stdenv.isDarwin then 14 else 10;
        normal = [{
          inherit family;
          style = "Normal";
        }];
        bold = [{
          inherit family;
          style = "ExtraBold";
        }];
        italic = [{
          inherit family;
          style = "Italic";
        }];
        bold_italic = [{
          inherit family;
          style = "ExtraBold-Italic";
        }];
      };
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      frame = "transparent";
    });
  };
}

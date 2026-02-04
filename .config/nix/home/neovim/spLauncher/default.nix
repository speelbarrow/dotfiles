{ config, lib, pkgs, ... }: {
  extraPlugins = [(with pkgs; vimUtils.buildVimPlugin {
    name = "spLauncher";
    src = fetchFromGitHub {
      owner = "speelbarrow";
      repo = "spLauncher.nvim";
      tag = "v0.3.2";
      sha256 = "8f9+XbQvZeGaviv8eWHnHV4r3ZQDElSoyNXypVPqXb0=";
    };
  })];
  extraFiles = {
    "after/plugin/spLauncher.lua".text = ''
      require 'spLauncher'.setup {
        keymap = {
          actions = {
            Run = "<A-s>R",
            Debug = "<A-s>D",
            Test = "<A-s>T",
            Build = "<A-s>B",
            Clean = "<A-s>C",
            Install = "<A-s>I",
          }
        }
      }
    '';
  } // (with builtins; lib.mapAttrs' 
    (name: _: let     
      actionMap = import ./${name} { inherit lib pkgs; };
    in {
      name = "after/ftplugin/${lib.removeSuffix ".nix" name}.lua";
      value.text = "vim.b.spLauncherActionMap = " + 
                   (config.lib.nixvim.toLuaObject (removeAttrs actionMap ["__raw"])) +
                   (if actionMap ? __raw then actionMap.__raw else "");
    })
    (
      lib.filterAttrs (name: value: let
          skip = ["default.nix" "platformio.nix"];
      in
        (builtins.all (x: name != x) skip) && (
          lib.warnIf (value != "regular") "skipping non-regular file '${value}'" value
        ) == "regular"
      ) (readDir ./.)
    )
  );
} 

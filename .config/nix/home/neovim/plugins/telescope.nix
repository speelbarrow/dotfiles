{ lib, pkgs, ... }: {
  dressing = {
    enable = true;
    lazyLoad.settings.event = "User DeferredUIEnter";

    settings = {
      input.relative = "win";
      select = {
        backend = [
          "telescope"
          "builtin"
        ];
        get_config.__raw = ''
          function(opts)
            if opts.kind == "codeaction" then
              return {
                builtin = { relative = "cursor" },
                telescope = require("telescope.themes").get_cursor(),
              }
            end
          end'';
      };
    };
  };
  telescope = {
    enable = true;
    # until nvim-telescope/telescope.nvim#3676 is merged
    # update ./project.nix as well
    package =
      with pkgs;
      vimUtils.buildVimPlugin {
        inherit (vimPlugins.telescope-nvim) meta pname version;
        src = fetchFromGitHub {
          owner = "speelbarrow";
          repo = "telescope.nvim";
          rev = "d1c032dd8505d2b6ff85a4af4c9089aee5e9fa3b";
          hash = "sha256-Q9zyWcOOvvEFUzu9b4xk1c7kdiEWsr15DLQ00On3X9I=";
        };
        dependencies = [ vimPlugins.plenary-nvim ];
      };
    lazyLoad.settings = {
      cmd = "Telescope";
      keys = [ "<A-v>" ];
    };

    extensions = {
      file-browser = {
        enable = true;
        settings = {
          hijack_netrw = true;
          hidden = {
            file_browser = true;
            folder_browser = true;
          };
        };
      };
      undo.enable = true;
    };

    keymaps =
      let
        leader = "<A-v>";
      in
      lib.mapAttrs'
        (n: v: {
          name = "${leader}${n}";
          value = {
            action = v;
            mode = [
              "n"
              "i"
              "v"
              "c"
              "t"
            ];
          };
        })
        {
          "" = "";
          a = "autocommands";
          b = "file_browser";
          B = "file_browser path=%:p:h";
          d = "diagnostics bufnr=0";
          D = "diagnostics";
          f = "find_files";
          F = "find_files cwd=%:p:h";
          h = "help_tags";
          H = "highlights";
          g = "builtin default_text=git";
          k = "keymaps";
          n = "notify";
          o = "oldfiles";
          # p = "projects";
          r = "live_grep";
          s = "symbols";
          u = "undo";
          v = "vim_options";
          "<Enter>" = "resume";
        };
    settings.defaults.initial_mode = "normal";
  };
  imports = [ pkgs.vimPlugins.telescope-symbols-nvim ];
}

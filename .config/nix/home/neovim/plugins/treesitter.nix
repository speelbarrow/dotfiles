{ ... }:
builtins.mapAttrs
  (
    n: v:
    {
      enable = true;
    }
    // v
  )
  {
    treesitter = {
      enable = true;

      settings = {
        incremental_selection.enable = true;
        indent.enable = true;
        highlight.enable = true;
        textobjects.enable = true;
      };
    };
    treesitter-context = {
      settings = {
        mode = "topline";
        multiwindow = true;
        zindex = 100;
      };
    };
    /*
      # BROKEN: see `https://github.com/nvim-treesitter/nvim-treesitter-locals` "Coming Soon"
      treesitter-refactor = {
        settings.smart_rename = {
          enable = true;
          keymaps.smart_rename = "<F2>";
        };
      };
    */
    treesitter-textobjects.settings.lsp_interop.enable = true;

    ts-autotag.lazyLoad.settings.event = "User FileOpened";
    ts-comments.lazyLoad.settings.event = "User FileOpened";
  }

{
  config,
  lib,
  pkgs,
  ...
}:
{
  copilot-lua = {
    enable = true;
    luaConfig.post = ''
      vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#969696", italic = true })
      vim.keymap.set({ 'n', 'v' }, "<M-CR>", "<Cmd>Copilot panel<CR>")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot://*",
        callback = function(args)
          for _, key in ipairs { "q", "<C-c>" } do
            vim.keymap.set("n", key, "<Cmd>q<CR>", { buffer = args.buf })
          end
        end
      })
    '';
    settings = {
      filetypes = {
        markdown = true;
        yaml = true;
      };
      panel.keymap = {
        accept = "<Enter>";
        jump_next = "<Down>";
        jump_prev = "<Up>";
        refresh = "<BS>";
      };
      suggestion = {
        hide_during_completion = false;
        keymap = {
          accept = "<S-Enter>";
          dismiss = "<S-BS>";
          next = "<S-Down>";
          prev = "<S-Up>";
        };
      };
      server_opts_overrides.settings.advanced.inlineSuggestCount = 3;
    };
  };
  copilot-chat = {
    enable = true;
    luaConfig.post = ''
      vim.keymap.set({ 'n', 'i', 'v', 't' }, "<M-S-CR>", "<Cmd>CopilotChat<CR>")
    '';
  };

  blink-cmp = {
    enable = true;
    settings = {
      completion = {
        documentation.window.border = "rounded";
        menu = {
          border = "rounded";
          draw.treesitter = [ "lsp" ];
          winblend = 15; # see `home/neovim/files/neovide.nix`
        };
        trigger.show_on_backspace = true;
      };
      signature = {
        enabled = true;
        window.border = "rounded";
      };
      keymap = {
        preset = "none";
        "<CR>" = [
          "accept"
          "fallback"
        ];
        "<Up>" = [
          "select_prev"
          "fallback"
        ];
        "<ScrollWheelUp>" = [
          "select_prev"
          "fallback"
        ];
        "<Down>" = [
          "select_next"
          "fallback"
        ];
        "<ScrollWheelDown>" = [
          "select_next"
          "fallback"
        ];
        "<Tab>" = [
          "snippet_forward"
          "fallback"
        ];
        "<S-Tab>" = [
          "snippet_backward"
          "fallback"
        ];
        "<S-CR>" = [
          {
            __raw = ''
              function()
                local copilot = require"copilot.suggestion"
                if copilot.is_visible() then
                  copilot.accept()
                  return true
                end
                return false
              end
            '';
          }
          "show"
          "hide_documentation"
          "show_documentation"
        ];
        "<S-BS>" = [
          "hide_documentation"
          "hide"
          "fallback_to_mappings"
        ];
      };
    };
  };

  lsp = {
    enable = true;
    lazyLoad.settings.event = "User FileOpened";
    inlayHints = true;

    keymaps = {
      extra =
        lib.mapAttrsToList
          (n: v: {
            action = v;
            key = n;
            mode = [
              "n"
              "i"
              "v"
              "t"
            ];
          })
          {
            "<F1>".__raw = ''
              function()

                        local buffer = vim.api.nvim_get_current_buf()
                        local client = vim.lsp.get_clients({ 
                          name = "otter-ls[" .. buffer .. "]"
                        })[1]
                        if client ~= nil 
                           and lang ~= nil 
                           and lang ~= vim.api.nvim_buf_get_option(buffer, "filetype") 
                        then
                          client.request(
                            vim.lsp.protocol.Methods.textDocument_hover,
                            vim.lsp.util.make_position_params()
                          )
                        else
                          vim.lsp.buf.hover()
                        end
                      end'';
            "<S-F1>" = "<Cmd>checkhealth vim.lsp<CR>";
            # F2: smartRename -> home/neovim/plugins/treesitter.nix
            "<F3>".__raw = "vim.lsp.buf.code_action";
            "<F4>".__raw = ''
              function()
                        require "telescope.builtin".lsp_definitions(require "telescope.themes".get_cursor {})
                      end'';
            "<S-F4>".__raw = ''
              function()
                        require "telescope.builtin".lsp_type_definitions(require "telescope.themes".get_cursor {})
                      end'';
            "<F5>".__raw = ''
              function() 
                        require "telescope.builtin".lsp_references(require "telescope.themes".get_cursor {})
                      end'';
            "<S-F5>".__raw = ''
              function()
                        require "telescope.builtin".lsp_implementations(require "telescope.themes".get_cursor {})
                      end'';
            "<F6>".__raw = "vim.diagnostic.open_float";
            "<F7>".__raw = "function() vim.lsp.buf.format { async = true } end";
            "<F8>".__raw = "require'copilot.suggestion'.toggle_auto_trigger";
            "<F9>".__raw = "function() vim.wo.wrap = not vim.wo.wrap end";
            "<F10>".__raw = "require'treesitter-context'.toggle";
            "<F11>".__raw = "function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end";
            "<F12>".__raw = "function() vim.wo.spell = not vim.wo.spell end";
          };
    };

    onAttach = ''
      if client and client.name ~= "copilot" then
        require'otter'.activate(nil, true, false, nil)
      end
    '';

    servers = import ../../../../mkDir.nix {
      args = { inherit config lib pkgs; };
      inherit lib;
      path = ./.;
    };
  };

  lsp-format = {
    enable = true;
    lazyLoad.settings.event = "LspAttach";
    settings = {
      lua.exclude = [ "lua_ls" ];
      sql.exclude = [ "sqls" ];
    };
  };
  otter = {
    enable = true;
    lazyLoad.settings.event = "LspAttach";
    autoActivate = false;
  };

  imports = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-lsp-endhints";
      src = builtins.fetchTarball {
        url = "https://github.com/chrisgrieser/nvim-lsp-endhints/archive/main.tar.gz";
      };
    })
  ];
  lz-n.plugins = [
    {
      __unkeyed-1 = "nvim-lsp-endhints";
      after.__raw = ''
        function()
                require'lsp-endhints'.setup()
              end'';
      event = "LspAttach";
    }
  ];
}

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
      -- Without this, `barbar` or `scope` will cache the buffer and it will break after first use
      vim.api.nvim_create_autocmd("BufHidden", {
        pattern = "copilot://*",
        callback = vim.schedule_wrap(function(args)
          vim.cmd.bw(args.buf)
        end)
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

  blink-cmp =
    let
      winblend = {
        # see `home/neovim/files/neovide.nix`
        __raw = "vim.g.neovide == true and 15 or vim.o.winblend";
      };
    in
    {
      enable = true;
      settings = {
        enabled.__raw = "function() return vim.bo.filetype ~= 'DressingInput' end";
        completion = {
          documentation = {
            window.border = "rounded";
            inherit winblend;
          };
          menu = {
            border = "rounded";
            draw.treesitter = [ "lsp" ];
            inherit winblend;
          };
          trigger.show_on_backspace = true;
        };
        signature = {
          enabled = true;
          window = {
            border = "rounded";
            inherit winblend;
          };
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
            "hide_documentation"
            {
              __raw = ''
                function()
                  local copilot = require"copilot.suggestion"
                  if copilot.is_visible() ~= nil and not require"blink-cmp".is_visible() then
                    copilot.accept()
                    return true
                  end
                end
              '';
            }
            "show_signature"
            "show"
            "show_documentation"
          ];
          "<S-BS>" = [
            "hide_documentation"
            "hide"
            "hide_signature"
            "fallback"
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
            "<F1>".__raw = "function() vim.lsp.buf.hover() end";
            /*
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
            */
            "<S-F1>" = "<Cmd>checkhealth vim.lsp<CR>";
            # F2: smartRename -> home/neovim/plugins/treesitter.nix
            # except not anymore because its broken!
            "<F2>".__raw = "vim.lsp.buf.rename";
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

  otter = {
    enable = true;
    lazyLoad.settings.event = "LspAttach";
    autoActivate = false;
  };
  rustaceanvim = {
    enable = true;
    settings = {
      server = {
        cmd.__raw = ''
          {
            "${pkgs.rust-analyzer}/bin/rust-analyzer",
            "--log-file",
            vim.env.HOME .. "/.local/state/nvim/rustacean.log"
          }
        '';
        default_settings.rust-analyzer = {
          cachePriming = {
            enable = true;
            numThreads = "logical";
          };
          cargo = {
            features = "all";
            targetDir = true;
          };
          semanticHighlighting.strings.enable = false;
        };
      };
      tools = {
        enable_clippy = false;
        enable_nextest = false;
        hover_actions.replace_builtin_hover = false;
      };
    };
  };

  imports = [
    (
      with pkgs;
      vimUtils.buildVimPlugin rec {
        name = "nvim-lsp-endhints";
        src = fetchFromGitHub {
          owner = "chrisgrieser";
          repo = name;
          rev = "a86e7ca7a92ef003008d7eb5d153c63bcc89f79c";
          hash = "sha256-RstC7vzBNkGtd7XohTQA6PrIc2etzFOPK/NBuC9eGrU=";
        };
      }
    )
  ];
  lz-n.plugins = [
    {
      __unkeyed-1 = "nvim-lsp-endhints";
      after.__raw = "function() require'lsp-endhints'.setup() end";
      event = "LspAttach";
    }
  ];
}

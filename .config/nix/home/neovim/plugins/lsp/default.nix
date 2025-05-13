{ config, lib, pkgs, ... }: {
  cmp = let
    makeMapping = mode: maps: builtins.mapAttrs (n: v: "{ ${mode} = ${v} }") ({
      "<CR>" = "cmp.mapping.confirm({ select = ${if mode != "c" then "true" else "false"} })";
      "<S-BS>" = ''function()
        if cmp.visible_docs() then
          cmp.close_docs()
        elseif cmp.visible() then
          cmp.abort()
        elseif copilot.is_visible() then
          copilot.dismiss()
        else
          fallback()
        end
      end'';
    } // maps);
    selectors = If: Else: prev: ''function(fallback)
      ${If prev}
        cmp.select_${if prev then "prev" else "next"}_item()
      else
        ${Else}
      end
    end'';
  in {
    enable = true;
    luaConfig.pre = ''
      local copilot = require "copilot.suggestion";
    '';

    settings = {
      sources = [
        {
          name = "nvim_lsp";
          group_index = 1;
        }
        {
          name = "nvim_lsp_signature_help";
          group_index = 2;
        }
        {
          name = "treesitter";
          group_index = 3;
        }
      ];

      mapping = let
        arrows = prev: selectors (prev: ''
        if cmp.visible_docs() then
          cmp.scroll_docs(${if prev then "-1" else "1"})
        elseif cmp.visible() then
        '') "fallback()" prev;
        tabs_base = elze: prev: selectors (prev: "if cmp.visible() then") elze prev;
        copilot = prev: tabs_base ''
          copilot.${if prev then "prev" else "next"}()
        '' prev;
        tabs = tabs_base "fallback()";
      in makeMapping "i" {
        "<Up>" = arrows true;
        "<Down>" = arrows false;
        "<ScrollWheelUp>" = arrows true;
        "<ScrollWheelDown>" = arrows false;
        "<Tab>" = tabs false;
        "<S-Tab>" = tabs true;
        "<S-Up>" = copilot true;
        "<S-Down>" = copilot false;
        "<S-ScrollWheelUp>" = tabs true;
        "<S-ScrollWheelDown>" = tabs false;
        "<S-CR>" = ''function()
          if cmp.visible_docs() then
            cmp.close_docs()
          elseif cmp.visible() then
            cmp.open_docs()
          elseif copilot.is_visible() then
            copilot.accept()
          else
            cmp.complete()
          end
        end'';
      };

      view.docs.auto_open = false;

      window = rec {
        completion.__raw = "cmp.config.window.bordered()";
        documentation = completion;
      };

      formatting.format.__raw = ''function(entry, vim_item)
        local icons = {
          kind = {
            Text = "󱩾",
            Method = "󱝒",
            Function = "󰒓",
            Constructor = "󱉜",
            Field = "󱝔",
            Variable = "󰏫",
            Class = "󰀼",
            Interface = "󰠥",
            Module = "󰏖",
            Property = "󰓹",
            Unit = "",
            Value = "󰎠",
            Enum = "󰖽",
            Keyword = "",
            Snippet = "󰲋",
            Color = "󰏘",
            File = "󰈙",
            Reference = "",
            Folder = "󰝰",
            EnumMember = "󰈍",
            Constant = "󰏿",
            Struct = "󰉺",
            Event = "",
            Operator = "",
            TypeParameter = "",
          },
          source = {
            nvim_lsp = "",
            snippy = "󰆐",
            treesitter = "󰙅",
          },
        }
        vim_item.kind = string.format("%s  %-20s | %s", icons.kind[vim_item.kind] or " ",
                                      vim_item.kind,
                                      icons.source[entry.source.name])
        return vim_item
      end'';
    };

    cmdline = let
      mapping = let
        arrows = prev: selectors (prev: "if cmp.get_selected_entry() ~= nil then") "fallback()" prev;
        tabs = prev: selectors (prev: "if cmp.visible() then") "cmp.complete()" prev;
      in makeMapping "c" {
        "<Up>" = arrows true;
        "<Down>" = arrows false;
        "<Tab>" = tabs false;
        "<S-Tab>" = tabs true;
      };
      buffer = {
        inherit mapping;
        sources = [ { name = "buffer"; } ];
        formatting.format = ''
        function(_, vim_item)
          vim_item.kind = ""
          return vim_item
        end
        '';
      };
    in {
      "/" = buffer;
      "?" = buffer;
      ":" = {
        inherit (buffer) mapping formatting;
        sources = [
          { name = "cmdline"; }
          { name = "async_path"; }
        ];
      };
    };
    filetype.gitcommit.sources = [
      { name = "git"; }
      { name = "buffer"; }
      { name = "async_path"; }
    ];
  };

  copilot-lua = {
    enable = true;
    luaConfig.post = ''
      vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#969696", italic = true })

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
        accept = "<S-Enter>";
        jump_next = "<S-Down>";
        jump_prev = "<S-Up>";
        refresh = "<S-BS>";
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

  lsp = {
    enable = true;
    lazyLoad.settings.event = "User FileOpened";
    inlayHints = true;

    keymaps = {
      extra = lib.mapAttrsToList (n: v: {
        action = v;
        key = n;
        mode = ["n" "i" "v"];
      }) {
        "<F1>".__raw = ''function()

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
        # F2: smartRename -> home/neovim/plugins/treesitter.nix
        "<F3>".__raw = "vim.lsp.buf.code_action";
        "<F4>".__raw = ''function()
          require "telescope.builtin".lsp_definitions(require "telescope.themes".get_cursor {})
        end'';
        "<F5>".__raw = "vim.lsp.buf.implementation";
        "<F6>".__raw = "vim.diagnostic.open_float";
        "<F10>".__raw = "require'copilot.suggestion'.toggle_auto_trigger";
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
  };
  otter = {
    enable = true;
    lazyLoad.settings.event = "LspAttach";
    autoActivate = false;
  };
  
  imports = [(pkgs.vimUtils.buildVimPlugin {
    name = "nvim-lsp-endhints";
    src = builtins.fetchTarball {
      url = "https://github.com/chrisgrieser/nvim-lsp-endhints/archive/main.tar.gz"; 
    };
  })];
  lz-n.plugins = [
    {
      __unkeyed-1 = "nvim-lsp-endhints";
      after.__raw = ''function()
        require'lsp-endhints'.setup()
      end'';
      event = "LspAttach";
    }
  ];
}

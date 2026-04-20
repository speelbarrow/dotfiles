{ ... }: {
  lualine = {
    enable = true;
    autoLoad = true;
    lazyLoad.enable = false;

    luaConfig.pre = ''
      local colors = require'dracula'.colors()
      local theme = require'lualine.themes.dracula-nvim'
      for mode, _ in pairs(theme) do
        local fg = theme[mode].b.fg
        theme[mode].b = { fg = colors.bright_white, bg = colors.selection }
        if not theme[mode].c then
          theme[mode].c = { fg = fg, bg = colors.black }
        else
          theme[mode].c.fg = fg
        end
      end
      theme.inactive.c.fg = "white"
    '';

    settings = {
      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch" "diff"];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            file_status = true;
            path = 3;
            symbols = {
              modified = "";
              readonly = "[RO]";
            };
          }
        ];
        lualine_x = [
          {
            __unkeyed-1 = "diagnostics";
            cond.__raw = "vim.diagnostic.is_enabled";
            sources = ["nvim_lsp"];
            sections = ["error" "warn" "info" "hint"];
            symbols = {
              error = "󱎘 ";
              warning = "󱈸 ";
              info = " ";
              hint = "󰙴 ";
            };
          }
          {
            __unkeyed-1 = "' '";
            cond.__raw = "function() return vim.b.copilot_suggestion_auto_trigger == true end";
          }
          {
            __unkeyed-1 = "'󰖶 '";
            cond.__raw = "function() return vim.wo.wrap end";
          }
          {
            __unkeyed-1 = "' '";
            cond.__raw = "require'treesitter-context'.enabled";
          }
          {
            __unkeyed-1 = "'󰔨 '";
            cond.__raw = "function() return vim.diagnostic.is_enabled() end";
          }
          {
            __unkeyed-1 = "'󱍓 '";
            cond.__raw = "function() return vim.wo.spell end";
          }
          "o:shiftwidth" "filetype" 
        ];
        lualine_y = ["encoding" "fileformat"];
        lualine_z = ["progress" "location"];
      };
      options = {
        globalstatus = true;
        theme.__raw = "theme";
      };
    };
  };
}

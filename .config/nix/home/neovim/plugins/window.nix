{ pkgs, ... }: {
  barbar.enable = true;
  scope = {
    enable = true;
    lazyLoad.settings.event = ["User DeferredUIEnter"];

    settings.hooks = { 
      pre_tab_leave.__raw = ''function()
        vim.api.nvim_exec_autocmds("User", {pattern = "ScopeTabLeavePre"})
      end'';
      post_tab_enter.__raw = ''function()
        vim.api.nvim_exec_autocmds("User", {pattern = "ScopeTabEnterPost"})
      end'';
    };
  };
  imports = [pkgs.vimPlugins.windows-nvim];
  lz-n.plugins = [
    {
      __unkeyed-1 = "windows";
      event = "WinNew";
      after.__raw = ''function()
        require "windows".setup {}
      end'';
    }
  ];
}

{ pkgs, ... }: {
  fugitive.enable = true;
  gitsigns = {
    enable = true;
    lazyLoad.settings.event = "User DeferredUIEnter";
    luaConfig.post = "vim.g.yadm_git_gitgutter_enabled = 0";

    settings = {
      attach_to_untracked = true;
      numhl = true;
      on_attach.__raw = ''function(bufnr)
        if vim.b[bufnr].gitsigns_status_dict.gitdir == vim.fn.stdpath "data":gsub("/nvim", "") ..
          "/yadm/repo.git" and vim.fn["fugitive#Head"]() == "" then
          vim.schedule_wrap(require 'gitsigns'.detach)(bufnr)
        end
      end'';
      preview_config.border = "rounded";
      _on_attach_pre.__raw = "function(_, cb) require 'gitsigns-yadm'.yadm_signs(cb) end";
    };
  };
  imports = with pkgs; [
    (vimUtils.buildVimPlugin {
      name = "gitsigns-yadm";
      src = fetchFromGitHub {
        owner = "purarue";
        repo = "gitsigns-yadm.nvim";
        rev = "9813de8c122c62ce27a83a80e27c9b4fb662b018";
        sha256 = "XDEA9ojm5tgu7hbt6K/LrJTrSnBm45+S0JFo6mKpbJo=";
      };
    })
    (vimUtils.buildVimPlugin {
      name = "yadm-git.vim";
      src = fetchFromGitHub {
        owner = "purarue";
        repo = "yadm-git.vim";
        rev = "e611bbdf6e7c2c0b3e265ca9edea83ebb91e7f9a";
        sha256 = "iQiuWtFkFssooAh3N3TXaNZ3Sbfhihs2o1bFV/eL7PU=";
      };
    })
  ];
}

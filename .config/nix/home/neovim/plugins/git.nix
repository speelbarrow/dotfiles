{ pkgs, ... }:
{
  fugitive.enable = true;
  gitsigns = {
    enable = true;
    lazyLoad.settings.event = "User DeferredUIEnter";
    luaConfig.post = "vim.g.yadm_git_gitgutter_enabled = 0";

    settings = {
      attach_to_untracked = true;
      numhl = true;
      on_attach.__raw = ''
        function(bufnr)
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
        rev = "da5655074ab8b2e910104de280ce528f7f91f823";
        hash = "sha256-sMnxGa7zqO9SMPMl+slc+Hlk2StsUAOxndfWemltT+w=";
      };
    })
    (vimUtils.buildVimPlugin {
      name = "yadm-git.vim";
      src = fetchFromGitHub {
        owner = "purarue";
        repo = "yadm-git.vim";
        rev = "90c4229795758c4c4967d0c4d7de8bc4559b5eb7";
        hash = "sha256-Ey1PAkwCPjDm5iSOzmveOH1+GThtw/4aSC16rZSK/ug=";
      };
    })
  ];
}

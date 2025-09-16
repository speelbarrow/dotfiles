{ lib, pkgs, ... }: {
  project-nvim = {
    enable = true;
    enableTelescope = true;
    lazyLoad.settings.event = ["User DeferredUIEnter"];
    package = pkgs.vimUtils.buildVimPlugin {
      pname = "project.nvim";
      version = "2025-04-14";
      src = pkgs.fetchFromGitHub {
        owner = "Spelis";
        repo = "project.nvim";
        rev = "da39a845d62056f701a5ed662bf8d043de2d03bd";
        sha256 = "v2C4NPR1y7gH13pkU34Tp/QRx0iTr5Rx48CBMfzPcvc=";
      };
    };
    settings = {
      ignore_lsp = [
        "clangd"
        "copilot"
        "lua_ls"
        "rust_analyzer"
        "taplo"
      ];
      patterns = [
        ".git"
        "Cargo.toml"
        "CMakeLists.txt"
        "pyproject.toml"
        "package.json"
        ">.config"
        ">Git"
        ">Scratch"
      ];
      scope_chdir = "tab";
      silent_chdir = false;
    };
  };
}

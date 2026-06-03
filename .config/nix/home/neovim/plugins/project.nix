{ ... }:
{
  project-nvim = {
    enable = true;
    # until nvim-telescope/telescope.nvim#3676 is merged
    enableTelescope = false;
    lazyLoad.settings.event = [ "User DeferredUIEnter" ];
    settings = {
      lsp.ignore = [
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
        "compile_commands.json"
        "package.json"
        "platformio.ini"
        "pyproject.toml"
        ">.config"
        ">Git"
        ">Scratch"
      ];
      scope_chdir = "tab";
      silent_chdir = false;
    };
  };
}

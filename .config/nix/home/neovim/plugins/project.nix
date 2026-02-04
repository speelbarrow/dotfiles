{ ... }: {
  project-nvim = {
    enable = true;
    enableTelescope = true;
    lazyLoad.settings.event = ["User DeferredUIEnter"];
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

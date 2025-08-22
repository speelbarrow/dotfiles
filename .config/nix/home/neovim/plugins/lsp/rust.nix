{ ... }: {
  rust_analyzer = {
    enable = true;
    installCargo = false;
    installRustc = false;
    /*rootDir = ''function(file)
      local root = vim.fs.root(file, "Cargo.toml")
      vim.notify(root, vim.log.levels.DEBUG)
      return root
    end'';*/
    package = (import <nixpkgs> { 
      overlays = [
        (import 
          (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz")
        )
      ]; 
    }).rust-bin.stable.latest.rust-analyzer;
    settings = {
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
}

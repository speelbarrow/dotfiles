{ ... }:
{
  rust_analyzer = {
    enable = true;
    installCargo = false;
    installRustc = false;
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

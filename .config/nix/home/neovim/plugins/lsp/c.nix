{ lib, pkgs, ... }: {
  arduino_language_server = {
    enable = true;
    extraOptions = {
      capabilities = rec {
        textDocument.semanticTokens.__raw = "vim.NIL";
        workspace = textDocument;
      };
      cmd = let
        config = if pkgs.stdenv.isDarwin then "Library/Arduino15" else ".arduino15";
      in [
        "arduino-language-server"
        "-cli-config"
        { __raw = ''vim.env.HOME .. "/${config}/arduino-cli.yaml"''; }
        "-format-conf-path"
        { __raw = ''vim.env.HOME .. "/.clang-format"''; }
        "-jobs"
        "0"
      ];
    };
    filetypes = ["arduino"];
  };

  clangd = rec {
    enable = true;
    rootMarkers = ["CMakeLists.txt"];
    settings.root_markers = rootMarkers;
  };
  cmake.enable = true;
}

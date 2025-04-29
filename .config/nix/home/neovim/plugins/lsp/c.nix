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
    package = pkgs.buildGoModule rec {
      name = src.repo;
      src = pkgs.fetchFromGitHub {
        owner = "arduino";
        repo = "arduino-language-server";
        tag = "0.7.7";
        sha256 = "twTbJ5SFbL4AIX+ffB0LdOYXUxh4SzmZguJSRdEo1lQ=";
      };
      vendorHash = "sha256-wXArVPzYmuiivx+8M86rrvfKsvCMtkN3WgXQByr5fC4=";
    };
  };

  clangd = {
    cmd = [
      "nix-shell"
      "-p"
      "clang-tools"
      "--command"
      (builtins.concatStringsSep " " [
        "clangd"
        "--background-index"
        "--background-index-priority=normal"
        "--completion-style=bundled"
        "--function-arg-placeholders"
        "--header-insertion=iwyu"
      ])
    ];
    enable = true;
    /*rootDir.__raw = ''function(fname)
      local root_files = {
        "CMakeLists.txt",
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac", -- AutoTools
      }
      return vim.fs.root(fname, unpack(root_files))
          or require "lspconfig.util".find_git_ancestor(fname)
          or vim.fn.expand "%:p:h"
    end'';*/
    extraOptions.capabilities.offsetEncoding = "utf-8";
  };

  cmake.enable = true;
}

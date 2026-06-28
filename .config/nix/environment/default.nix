{
  lib,
  isDarwin,
  pkgs,
  ...
}:
{
  environment = {
    extraInit = lib.concatLines (
      import ../mkDir.nix {
        args = { inherit pkgs; };
        inherit lib;
        path = ./init;
      }
    );

    # Required for home-manager.programs.zsh.enableCompletion to work properly.
    pathsToLink = [ "/share/zsh" ];

    shellAliases = {
      rebuild =
        let
          sudo = if isDarwin || builtins.pathExists "/etc/nixos" then "HOME=~root sudo " else "";
          command =
            if isDarwin then
              "${sudo}darwin-rebuild"
            else if builtins.pathExists "/etc/nixos" then
              "${sudo}nixos-rebuild"
            else
              "home-manager";
          cores = if isDarwin then "sysctl -n hw.ncpu" else "nproc --all";
        in
        ''
          ${sudo}nix-channel --update --log-format internal-json -v |& nom --json
          ${command} switch --cores $(${cores}) --max-jobs $(${cores}) --log-format \
            internal-json -v |& nom --json
        '';

      cat = "bat --theme Dracula";
      eza = "command eza -l --header --git --icons";
      z =
        let
          ignore = builtins.concatStringsSep "|" (
            [
              ".git"

              "build"
              "out"

              "Cargo.lock"
              "target"

              "node_modules"

              ".mypy_cache"
              "__pycache__"
              ".ropeproject"
              ".venv"
            ]
            ++ lib.optionals isDarwin [ ".DS_Store" ]
          );
        in
        ''
          eza $([ "$(dirname $PWD)" != "$(dirname $HOME)" ] && echo -n " -a ") \
                      --git-ignore \
                      --ignore-glob="${ignore}"'';
      za = "eza -a";
      zz = "z --tree";
      zza = "za --tree";

      ccmake = "ccmake -S . -B build";

      nix-zsh = ''nix-shell --run "$SHELL --login"'';
      nom-zsh = ''nom-shell --run "$SHELL --login"'';
    };

    systemPackages = with pkgs; [
      # The order is important!
      cmake
      llvmPackages.libcxxClang
      llvmPackages.libllvm
      llvmPackages.libcxx

      arduino-cli
      avrdude
      bat
      bun
      cargo-expand
      cargo-generate
      chatterino7
      cmakeCurses
      curl
      eza
      ffmpeg
      git
      gnumake
      godot
      nix-output-monitor
      nix-tree
      platformio-core
      probe-rs-tools
      python3
      ripgrep
      rustup
      rust-bindgen
      sl
      virtualenv
      wget
      wireguard-tools
      yadm
    ];

    variables = {
      CMAKE_EXPORT_COMPILE_COMMANDS = "on";
    };
  };
}

{ lib, isDarwin, pkgs, ... }: {
  environment = {
    extraInit = lib.concatLines (import ../mkDir.nix {
      args = { inherit pkgs; };
      inherit lib;
      path = ./init;
    });

    # Required for home-manager.programs.zsh.enableCompletion to work properly.
    pathsToLink = ["/share/zsh"];

    shellAliases = {
      rebuild = let
        command = if isDarwin
                  then "sudo darwin-rebuild"
                  else if builtins.pathExists "/etc/nixos"
                  then "sudo nixos-rebuild"
                  else "home-manager";
        cores = if isDarwin
                then "sysctl -n hw.ncpu"
                else "nproc --all";
        sudo = if isDarwin || builtins.pathExists "/etc/nixos" then "sudo" else "";
      in ''
        ${sudo} nix-channel --update
        ${sudo} ${command} switch --cores $(${cores}) --max-jobs $(${cores}) |& nom
      '';

      eza = "command eza -l --header --git --icons";
      z = let
        ignore = builtins.concatStringsSep "|" ([
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
        ] ++ lib.optionals isDarwin [".DS_Store"]);
      in ''eza $([ "$(dirname $PWD)" != "$(dirname $HOME)" ] && echo -n " -a ") \
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
      clang-tools
      llvmPackages.libstdcxxClang
      llvmPackages.libllvm
      llvmPackages.libcxx

      arduino-cli
      avrdude
      cargo-expand
      cargo-generate
      clang
      cmakeCurses
      curl
      eza
      ffmpeg
      git
      gnumake
      nix-output-monitor
      platformio-core
      probe-rs-tools
      python3
      ripgrep
      rustup
      sl
      wget
      wireguard-tools
      yadm
    ];

    variables = {
      CMAKE_EXPORT_COMPILE_COMMANDS="on";
    };
  };
  nixpkgs.overlays = with pkgs; [
    (final: prev: {
      probe-rs-tools = rustPlatform.buildRustPackage rec {
        pname = "probe-rs-tools";
        version = "0.27.0";

        src = fetchFromGitHub {
          owner = "probe-rs";
          repo = "probe-rs";
          rev = "v${version}";
          sha256 = "xtUaGJyzr0uQUb/A+7RmOVVgrXIctr2I9gLPU2/rXso=";
        };

        cargoHash = "sha256-acGLTbWI0SHspFISWw5Lj+sqn5HE4du5jTC3NS5zzh8=";

        buildAndTestSubdir = pname;

        nativeBuildInputs = [
          cmake
          gitMinimal
          pkg-config
          zsh
        ];

        buildInputs = [
          libusb1
          openssl
        ];

        checkFlags = [
          "--skip=cmd::dap_server::server::debugger::test::attach_request"
          "--skip=cmd::dap_server::server::debugger::test::attach_with_flashing"
          "--skip=cmd::dap_server::server::debugger::test::disassemble::instructions_after_and_not_including_the_ref_address"
          "--skip=cmd::dap_server::server::debugger::test::disassemble::instructions_before_and_not_including_the_ref_address_multiple_locations"
          "--skip=cmd::dap_server::server::debugger::test::disassemble::instructions_including_the_ref_address_location_cloned_from_earlier_line"
          "--skip=cmd::dap_server::server::debugger::test::disassemble::negative_byte_offset_of_exactly_one_instruction_aligned_"
          "--skip=cmd::dap_server::server::debugger::test::disassemble::positive_byte_offset_that_lands_in_the_middle_of_an_instruction_unaligned_"
          "--skip=cmd::dap_server::server::debugger::test::launch_and_threads"
          "--skip=cmd::dap_server::server::debugger::test::launch_with_config_error"
          "--skip=cmd::dap_server::server::debugger::test::test_initalize_request"
          "--skip=cmd::dap_server::server::debugger::test::test_launch_and_terminate"
          "--skip=cmd::dap_server::server::debugger::test::test_launch_no_probes"
          "--skip=cmd::dap_server::server::debugger::test::wrong_request_after_init"
          "--skip=util::cargo::test::get_binary_artifact_with_cargo_config"
          "--skip=util::cargo::test::get_binary_artifact_with_cargo_config_toml"
          "--skip=util::cargo::test::get_binary_artifact"
          "--skip=util::cargo::test::library_with_example_specified"
          "--skip=util::cargo::test::multiple_binaries_in_crate_select_binary"
          "--skip=util::cargo::test::workspace_binary_package"
          "--skip=util::cargo::test::workspace_root"
        ];

        meta = with lib; {
          description = "CLI tool for on-chip debugging and flashing of ARM chips";
          homepage = "https://probe.rs/";
          changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
          license = with licenses; [
            asl20 # or
            mit
          ];
          maintainers = with maintainers; [
            xgroleau
            newam
          ];
        };
      };
    })
  ];
}

{ pkgs, ... }: {
  clangd = let
    clang-tools = pkgs.clang-tools.override {
      clang = pkgs.llvmPackages.clang-unwrapped;
    };
  in {
    cmd = ["${clang-tools.outPath}/bin/clangd" 
      "--log=verbose"
      "--query-driver=/**/.platformio/**/*-g++"
    ];
    enable = true;
    filetypes = ["arduino" "c" "cpp" "objc" "objcpp" "cuda"];
    package = clang-tools;
  };
  cmake.enable = true;
}

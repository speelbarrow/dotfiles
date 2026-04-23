{ pkgs, ... }: {
  nixd = {
    enable = true;
    package = with pkgs; symlinkJoin {
      name = "nixd";
      meta.mainProgram = "nixd";
      paths = [nixd nixfmt];
    };
  };
}

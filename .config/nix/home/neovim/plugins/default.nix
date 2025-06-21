{ lib, ... } @ args: import ../../../mkDir.nix {
  inherit args lib;
  path = ./.;
  extra = [{
    crates = {
      enable = true;
      lazyLoad.settings.event = "BufEnter *Cargo.toml";
    };
    indent-blankline = {
      enable = true;
      lazyLoad.settings.event = "User FileOpened";
    };
    lz-n.enable = true;
    web-devicons.enable = true;
  }];
}

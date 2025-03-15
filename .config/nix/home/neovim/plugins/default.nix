{ lib, pkgs, ... } @ args: import ../../../mkDir.nix {
  inherit args lib;
  path = ./.;
  extra = [{
    crates = {
      enable = true;
      lazyLoad.settings.event = "BufEnter *Cargo.toml";

      package = pkgs.vimUtils.buildVimPlugin {
        pname = "crates.nvim";
        version = "2025-02-20";
        src = pkgs.fetchFromGitHub {
          owner = "saecki";
          repo = "crates.nvim";
          rev = "1803c8b5516610ba7cdb759a4472a78414ee6cd4";
          sha256 = "xuRth8gfX6ZTV3AUBaTM9VJr7ulsNFxtKEsFDZduDC8=";
        };
      };
    };
    indent-blankline = {
      enable = true;
      lazyLoad.settings.event = "User FileOpened";
    };
    lz-n.enable = true;
    web-devicons.enable = true;
  }];
}

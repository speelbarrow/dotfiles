{ pkgs, ... }: {
  home = let 
    user = import ../user.nix pkgs.stdenv.isDarwin;
  in {
    stateVersion = import ../version.nix;
    username = user.name;
    homeDirectory = user.home;

    packages = with pkgs; [
      wireshark
      typst
    ];
  };
  programs.home-manager.enable = true;
}

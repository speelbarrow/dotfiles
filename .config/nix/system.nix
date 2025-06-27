{ isDarwin, ... }: let
  version = import ./version.nix;
in {
  system = {
    stateVersion = if isDarwin then 5 else version;
  };
}

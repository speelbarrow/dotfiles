{ config, isDarwin, ... }: {
  nix.nixPath = let
    prefix = if isDarwin then "darwin" else "nixos";
    home = if isDarwin then "Users" else "home";
  in ["${prefix}-config=/${home}/speelbarrow/.config/nix/configuration.nix"];
}

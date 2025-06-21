{ config, isDarwin, ... }: {
  nix.nixPath = let
    prefix = if isDarwin then "darwin" else "nixos";
    home = if isDarwin then "Users" else "home";
  in ["${prefix}-config=/${home}/${config.system.primaryUser}/.config/nix/configuration.nix"];
}

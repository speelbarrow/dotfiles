{ pkgs, ... }: {
  base = if pkgs.stdenv.isDarwin 
         then "sudo nix-channel --update && sudo darwin-rebuild"
         else if builtins.pathExists /etc/nixos
         then "sudo nix-channel --update && sudo nixos-rebuild"
         else "nix-channel --update && home-manager";
  run = {
    handler = "switch |& nom";
    config.window.focus = "insert";
  };
  debug = {
    handler = "switch --show-trace |& nom";
    config.window.focus = "insert";
  };
  build = {
    handler = "build |& nom";
    config.window.focus = "insert";
  };
  test = {
    handler = "check |& nom";
    config.window.focus = "insert";
  };
}

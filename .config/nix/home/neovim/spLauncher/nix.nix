{ pkgs, ... }: {
  base = if pkgs.stdenv.isDarwin 
         then "sudo darwin-rebuild"
         else if builtins.pathExists /etc/nixos
         then "sudo nixos-rebuild"
         else "home-manager";
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

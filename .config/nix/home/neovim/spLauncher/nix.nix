{ pkgs, ... }:
let
  sudo = if pkgs.stdenv.isDarwin || builtins.pathExists /etc/nixos then "sudo " else "";
  prefix = "HOME=~root ${sudo}";
  suffix = "--log-format internal-json -v |& nom --json";
in
{
  base =
    if pkgs.stdenv.isDarwin then
      "${prefix}nix-channel --update ${suffix} && ${prefix}darwin-rebuild"
    else if builtins.pathExists /etc/nixos then
      "${prefix}nix-channel --update ${suffix} && ${prefix}nixos-rebuild"
    else
      "nix-channel --update ${suffix} && home-manager";
  run = {
    handler = "switch ${suffix}";
    config.window.focus = "insert";
  };
  debug = {
    handler = "switch --show-trace ${suffix}";
    config.window.focus = "insert";
  };
  build = {
    handler = "build ${suffix}";
    config.window.focus = "insert";
  };
  test = {
    handler = "check ${suffix}";
    config.window.focus = "insert";
  };
}

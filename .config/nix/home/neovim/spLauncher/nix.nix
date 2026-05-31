{ pkgs, ... }:
let
  sudo = if pkgs.stdenv.isDarwin || builtins.pathExists /etc/nixos then "HOME=~root sudo " else "";
  suffix = "--log-format internal-json -v |& nom --json";
in
{
  base =
    if pkgs.stdenv.isDarwin then
      "${sudo}nix-channel --update ${suffix} && ${sudo}darwin-rebuild"
    else if builtins.pathExists /etc/nixos then
      "${sudo}nix-channel --update ${suffix} && ${sudo}nixos-rebuild"
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

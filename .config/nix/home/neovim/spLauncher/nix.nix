{ pkgs, ... }:
{
  run = "nom-zsh %";
  Run = "nix-zsh %";
  debug = "nom-zsh --show-trace %";
  Debug = "nix-zsh --show-trace %";
  build = "nom-build %";
  Build = "nom-build --show-trace %";
  __raw =
    let
      sudo = if pkgs.stdenv.isDarwin || builtins.pathExists /etc/nixos then "HOME=~root sudo " else "";
      suffix = "--log-format internal-json -v |& nom --json";
    in
    ''
      if vim.fn.expand("%:p"):find("/.config/nix/", nil, true) ~= nil then 
        vim.b.spLauncherActionMap = {
          base = "${
            if pkgs.stdenv.isDarwin then
              "${sudo}nix-channel --update ${suffix} && ${sudo}darwin-rebuild"
            else if builtins.pathExists /etc/nixos then
              "${sudo}nix-channel --update ${suffix} && ${sudo}nixos-rebuild"
            else
              "nix-channel --update ${suffix} && home-manager"
          }",
          run = {
            handler = "switch ${suffix}",
            config = {
              window = {
                focus = "insert"
              }
            }
          },
          debug = {
            handler = "switch --show-trace ${suffix}",
            config = {
              window = {
                focus = "insert"
              }
            }
          },
          build = {
            handler = "build ${suffix}",
            config = {
              window = {
                focus = "insert"
              }
            }
          },
          test = {
            handler = "check ${suffix}",
            config = {
              window = {
                focus = "insert"
              }
            }
          },
        }
      end
    '';
}

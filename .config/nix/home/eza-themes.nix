{ pkgs, ... }:
with pkgs;
{
  home.file."${
    if stdenv.isDarwin then "Library/Application Support" else ".config"
  }/eza/theme.yml".source =
    "${
      (fetchFromGitHub {
        owner = "eza-community";
        repo = "eza-themes";
        rev = "add4c72c546992b8db674d6d3eea315bf2111b9a";
        hash = "sha256-toqj3bv2kCC2FHbGfeFpS3g9DoxQeZ7cwPYVpD8cfgg=";
      }).outPath
    }/themes/dracula.yml";
}

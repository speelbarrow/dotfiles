{ pkgs, ... }:
with pkgs;
{
  imports = lib.optionals stdenv.isDarwin [
    (vimUtils.buildVimPlugin {
      name = "vim-plist";
      src = fetchFromGitHub {
        owner = "darfink";
        repo = "vim-plist";
        rev = "aa781a387c70a9ea30cbce8da988e19693f5aaec";
        hash = "sha256-auX4yO6pC5wHVDrWGQL/S87ySOcA2/44algtGwjLLVE=";
      };
    })
  ];
}

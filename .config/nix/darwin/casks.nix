pkgs: if pkgs.stdenv.isDarwin
      then import (builtins.fetchGit { url = "https://github.com/jacekszymanski/nixcasks"; }) {
        inherit pkgs;
        osVersion = "tahoe";
        localAdditions = ./.;
      }
      else pkgs

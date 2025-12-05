{ pkgs, ... }: {
  programs.git = {
    enable = true;

    settings = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      user = {
        name = "Noah Friedman";
        email = "speelbarrow@speely.net";
      };
    };
    
    ignores = if pkgs.stdenv.isDarwin
              then [".DS_Store"]
              else [];
    signing = {
      key = null;
      signByDefault = true;
    };
  };

  programs.gpg = {
    enable = true;
    publicKeys = [
      { source = ./gmail.pub.asc; }
      { source = ./speely.pub.asc; }
    ];
  };
}

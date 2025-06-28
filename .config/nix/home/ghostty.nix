{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-style-bold = "ExtraBold";
      font-style-bold-italic = "ExtraBold-Italic";
      font-size = if pkgs.stdenv.isDarwin then 14 else 10;
      font-synthetic-style = false;
      theme = "Dracula+";
      cursor-style = "underline";
      cursor-click-to-move = true;
      background-opacity = 0.9;
      window-padding-balance = true;
      quit-after-last-window-closed = true;
      shell-integration-features = "no-cursor";
      bold-is-bright = true;
      auto-update = "off";
    };
  };
}

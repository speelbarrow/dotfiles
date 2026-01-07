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
      shell-integration-features = "no-cursor,ssh-terminfo";
      bold-is-bright = true;
      auto-update = "off";
      keybind = [
        "f1=set_font_size:10"
        "f2=set_font_size:14"
        "f3=set_font_size:18"
      ];
    };
  };
}

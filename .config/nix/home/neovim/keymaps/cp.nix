{ lib, modifier, ... }: let
  paste = "<${modifier}-v>";
in [
  {
    action = ''"*y'';
    key = "<${modifier}-c>";
    mode = "v";
  }
  {
    action = ''<Cmd>normal "*p<CR>'';
    key = paste;
    mode = ["n" "i" "v"];
  }
  {
    action = ''<C-\><C-n>"*pa'';
    key = paste;
    mode = "t";
  }
  {
    action = ''<Cmd>normal "*P<CR>'';
    key = lib.toUpper paste;
    mode = ["n" "i" "v"];
  }
]

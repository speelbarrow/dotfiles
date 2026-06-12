{ ... }:
let
  leader = "<M-d>";
  warn = import ./warn.nix;
in
map
  (
    { key, action }:
    {
      action = if action ? __raw then action else "<Cmd>${action}<CR>";
      key = "${leader}${key}";
      mode = [
        "n"
        "i"
        "v"
      ];
    }
  )
  [
    {
      key = "b";
      action = "DapToggleBreakpoint";
    }
    {
      key = "B";
      action = warn "clear breakpoints" "DapClearBreakpoints";
    }
    {
      key = "c";
      action = "DapContinue";
    }
    {
      key = "i";
      action = "DapStepInto";
    }
    {
      key = "o";
      action = "DapStepOut";
    }
    {
      key = "q";
      action = "DapTerminate";
    }
    {
      key = "s";
      action = "DapStepOver";
    }
    {
      key = "u";
      action.__raw = "require'dapui'.toggle";
    }
  ]

{ ... }: [
  {
    action.__raw = ''
      function()
        vim.cmd.cd "%:p:h"
        vim.schedule(function()
          vim.notify("cd: " .. vim.fn.getcwd())
        end)
      end
    '';
    key = "<M-c>";
    mode = [
      "n"
      "i"
      "v"
      "c"
    ];
  }
]

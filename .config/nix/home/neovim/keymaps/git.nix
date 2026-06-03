{ lib, ... }:
let
  leader = "<A-g>";
  mode = [
    "n"
    "i"
  ];

  mkAction =
    follower: body:
    map
      (
        { action, mode }:
        {
          action = if action ? __raw then action else "<Cmd>${action}<CR>";
          key = "${leader}${follower}";
          inherit mode;
        }
      )
      (
        if body ? withV then
          lib.warnIf (body ? action) "using 'withV' instead of 'action'" [
            {
              action = body.withV;
              inherit mode;
            }
            {
              action = if body.withV ? __raw then body.withV else "'<,'>${body.withV}";
              mode = "v";
            }
          ]
        else
          [ ((if body ? action then body else { action = body; }) // { inherit mode; }) ]
      );

  fallback = cmd: fb: {
    __raw = ''
      function()
            if not pcall(vim.cmd.Telescope, "git_${cmd}") then
              vim.cmd("Git ${fb}")
            end
          end'';
  };
  warn = import ./warn.nix;
in
lib.mapAttrsToList mkAction {
  a.withV = "Gitsigns stage_hunk";
  b = fallback "branches" "branch";
  c = "Git commit";
  d.withV = "Gitsigns preview_hunk";
  l = fallback "commits" "log";
  n = "Gitsigns next_hunk";
  p = "Git push | Git push --tags";
  r.withV = warn "reset hunk" "Gitsigns reset_hunk";
  s = fallback "status" "status";
  t = "Git push --tags";
  u = "Gitsigns undo_stage_hunk";
  x.__raw = ''
    function()
        vim.cmd "Git commit"
        vim.api.nvim_create_autocmd("User", {
          pattern = "FugitiveChanged",
          once = true,
          command = "Git push",
        })
      end'';
  A = "Gitsigns stage_buffer";
  C = warn "amend commit" "Git commit --amend";
  L = fallback "bcommits" "log %";
  N = "Gitsigns prev_hunk";
  P = warn "force push" "Git push -f";
  R = warn "reset buffer" "Gitsigns reset_buffer";
  S = fallback "stash" "stash list";
  X = warn "amend commit and force push" {
    __raw = ''
      function()
          vim.cmd "Git commit --amend"
          vim.api.nvim_create_autocmd("User", {
            pattern = "FugitiveChanged",
            once = true,
            command = "Git push -f",
          })
        end'';
  };
  "<C-a>" = "Git add .";
  "<C-x>".__raw = ''
    function()
        vim.cmd "Git add .";
        vim.cmd "tab Git commit";
        vim.api.nvim_create_autocmd("User", {
          pattern = "FugitiveChanged",
          once = true,
          command = "Git push",
        })
      end'';
}

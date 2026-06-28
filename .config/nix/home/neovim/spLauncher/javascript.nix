{ ... }: {
  base = "bun";
  run = "run %";
  build = "build %";
  test = true;
  __raw = ''
    ${(import ./web.nix).__raw}
    if vim.api.nvim_buf_get_name(0):sub(-4) == ".str" then
      vim.b.spLauncherActionMap = {
        run = function() vim.cmd "StrudelLaunch" end,
        debug = function() vim.cmd "StrudelStop" end,
        build = function() vim.cmd "StrudelUpdate" end,
        test = function() vim.cmd "StrudelToggle" end,
      }
    end
  '';
}

{ ... }: {
  base = "python3";
  run = "%";
  debug = "-m pdb %";
  build = "-m py_compile %";
  test = "-m unittest %";
  __raw = ''
    if vim.fs.root(0, { 'platformio.ini' }) ~= nil then
      ${import ./platformio.nix}
    end
 '';
}

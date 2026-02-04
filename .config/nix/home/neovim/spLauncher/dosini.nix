{ ... }: {
  __raw = ''
    if vim.fn.expand("%:t") == "platformio.ini" then
      ${import ./platformio.nix}
    end
  '';
}

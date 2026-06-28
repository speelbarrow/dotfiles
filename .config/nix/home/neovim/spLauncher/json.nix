{ ... }: {
  __raw = ''
    if vim.fn.expand("%:t") == "package.json" then
      ${(import ./web.nix).__raw}
    end
  '';
}

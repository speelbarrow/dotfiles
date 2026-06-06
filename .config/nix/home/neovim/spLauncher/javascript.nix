{ ... }: {
  base = "bun";
  run = "run %";
  build = "build %";
  test = true;
  __raw = import ./web.nix;
}

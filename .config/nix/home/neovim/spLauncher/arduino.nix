{ ... }: rec {
  base = "arduino-cli";
  build.__raw = ''"compile -j" .. #vim.uv.cpu_info()'';
  run.__raw = build.__raw + '' .. " -u && arduino-cli monitor --config 115200"'';
}

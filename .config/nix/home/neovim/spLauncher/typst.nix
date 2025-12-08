{ ... }: {
  run.__raw = "function() vim.cmd 'TypstPreview' end";
  build = "typst compile %";
}

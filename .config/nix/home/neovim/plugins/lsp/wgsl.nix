{ ... }: {
  wgsl_analyzer = {
    enable = true;
    settings.wgsl-analyzer.inlayHints.structLayoutHints = true;
  };
}

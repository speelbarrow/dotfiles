{ ... }: {
  run = {
    handler.__raw = "vim.cmd.MarkdownPreview";
    config = {
      notify = false;
      silent = true;
    };
  };
}

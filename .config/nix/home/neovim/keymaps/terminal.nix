{ mode, ... }: [
  {
    action.__raw = ''function()
      local command = "sp +terminal"
      if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "buftype") == "terminal" then
        command = "v" .. command
      end
      command = "<Cmd>" .. command .. "<CR>"
      local mode = vim.api.nvim_get_mode().mode
      if mode ~= "i" and mode ~= "t" then
        command = command .. "i"
      end
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(command, true, false, true),
        'n',
        false
      )
    end'';
    key = "<A-t>";
    inherit mode;
  }
  {
    action = "<Cmd>terminal<CR>i";
    key = "<A-T>";
    inherit mode;
  }
  {
    action = ''<C-\><C-n>'';
    key = "<Esc>";
    mode = "t";
  }
  (map (x: {
    action.__raw = ''function()
      vim.fn.chansend(
        vim.b.terminal_job_id,
        vim.api.nvim_replace_termcodes("<${x}>", true, false, true)
      )
    end'';
    key = "<S-${x}>";
    mode = "t";
  }) ["Esc" "Space"])
]

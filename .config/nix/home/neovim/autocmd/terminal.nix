{ ... }: [
  {
    callback.__raw = ''function(args)
      local callback = function(args, disable)
        local winid = vim.fn.win_findbuf(args.buf)[1]
        for option, value in pairs {
          number = disable ~= true,
          wrap = disable ~= true,
          spell = disable ~= true,
        } do
          if winid ~= nil and vim.wo[winid] ~= nil then
            vim.wo[winid][option] = value
          end
        end
      end
      callback(args, true)
      vim.api.nvim_create_autocmd("BufWinEnter", {
        buffer = args.buf,
        callback = function(args) callback(args, true) end
      })
      vim.api.nvim_create_autocmd("BufWinLeave", {
        buffer = args.buf,
        callback = callback,
        once = true,
      })
    end'';
    event = "TermOpen";
    nested = true;
  }
]

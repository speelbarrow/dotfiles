{ ... }: [
  {
    event = "BufWritePre";
    callback.__raw = ''
      ---@param args vim.api.keyset.create_autocmd.callback_args
      function(args)
        ---@type { [string]: string | string[] }
        local exclude = {
          lua = "lua_ls",
        }

        if not vim.b[args.buf].noFormatOnSave then
          local excludes = exclude[vim.bo[args.buf].filetype] or {}
          if type(excludes) == "string" then
            excludes = { excludes }
          end

          vim.lsp.buf.format({ 
            async = true,
            bufnr = args.buf,
            ---@param client vim.lsp.Client
            filter = function(client)
              for _, name in ipairs(excludes) do 
                if client.name == name then
                  return false
                end
              end 
              return true
            end,
          })
        end
      end
    '';
  }
]

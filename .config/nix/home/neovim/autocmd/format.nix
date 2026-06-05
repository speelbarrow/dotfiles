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

          local candidates = vim.tbl_map(
            ---@param client vim.lsp.Client
            function(client) return client.id end,
            vim.tbl_filter(
              function(client) return not vim.list_contains(excludes, client.name) end, 
              vim.lsp.get_clients({
                bufnr = args.buf,
                method = "textDocument/formatting"
              })
            )
          )

          if not vim.tbl_isempty(candidates) then
            vim.lsp.buf.format({
              bufnr = args.buf,
              filter = function(client) return vim.list_contains(candidates, client.id) end
            })
          end
        end
      end
    '';
  }
]

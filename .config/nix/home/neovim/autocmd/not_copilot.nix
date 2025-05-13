{ ... }: [{
  callback.__raw = ''function(args) 
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name ~= "copilot" then
      vim.api.nvim_exec_autocmds("User", {
        pattern = "NotCopilot",
      })
    end
  end'';
  event = ["LspAttach"];
}]

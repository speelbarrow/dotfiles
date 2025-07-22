{ pkgs, ... }: {
  programs.sqls = {
    enable = true;
    settings.connections = [
      {
        driver = "sqlite3";
        dataSourceName = ":memory:";
      }
    ];
  };
  programs.nixvim.lsp.servers.sqls.enable = true;
}


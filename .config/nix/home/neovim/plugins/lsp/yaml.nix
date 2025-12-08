{ ... }: {
  yamlls = {
    enable = true;
    settings = {
      schemas."https://www.schemastore.org/hayagriva" = "*.bib";
      schemaStore.enable = true;
    };
  };
}

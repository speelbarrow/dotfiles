{ ... }: {
  eslint.enable = true;
  ts_ls = {
    enable = true;
    settings = rec {
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all";
          includeInlayParameterNameHintsWhenArgumentMatchesName = true;
          includeInlayVariableTypeHints = true;
          includeInlayFunctionParameterTypeHints = true;
          includeInlayVariableTypeHintsWhenTypeMatchesName = true;
          includeInlayPropertyDeclarationTypeHints = true;
          includeInlayFunctionLikeReturnTypeHints = true;
          includeInlayEnumMemberValueHints = true;
        };
      };
      typescript = javascript;
    };
  };
}

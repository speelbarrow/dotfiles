{ ... }: {
  "after/queries/rust/injections.scm".text = ''
  ;; extends
  (macro_invocation
      macro: [
        (scoped_identifier
          name: (_) @_macro_name)
        (identifier) @_macro_name
      ]
      (token_tree (raw_string_literal (string_content) @injection.content))
      (#any-of? @_macro_name "query")
      (#set! injection.include-children)
      (#set! injection.language "sql"))
  '';
}

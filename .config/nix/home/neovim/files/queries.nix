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
  (macro_invocation
      macro: [
        (scoped_identifier
          name: (_) @_macro_name)
        (identifier) @_macro_name
      ]
      (token_tree (_) (raw_string_literal (string_content) @injection.content))
      (#any-of? @_macro_name "query_as")
      (#set! injection.include-children)
      (#set! injection.language "sql"))
  (call_expression
    function: [
      (generic_function 
        function: [    
          (scoped_identifier
            name: (_) @_func_name)
          (identifier) @_func_name
        ])
      (scoped_identifier
        name: (_) @_func_name)
      (identifier) @_func_name
    ]
    arguments: (arguments (raw_string_literal (string_content) @injection.content))
    (#any-of? @_func_name "query" "query_as")
    (#set! injection.include-children)
    (#set! injection.language "sql")
    )
  '';
}

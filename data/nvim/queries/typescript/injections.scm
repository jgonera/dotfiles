;; extends

; Typed sql tags, e.g.
; sql<{ name: string }[]>`SELECT name FROM users`
(call_expression
  function: (non_null_expression
    (instantiation_expression
      (await_expression
        (identifier) @_id ))) @foo
  arguments: (template_string) @injection.content
  (#eq? @_id "sql")
  (#set! injection.language "sql")
  (#set! injection.include-children))

function(expr_compile_statement) # context, ast
  map_tryget(${ast} statement_ast children)
  ast_eval(${statement_ast} ${context})
  ans(statement)
  set(res "
  # expr_compile_statement
  ${statement}
  # end of expr_compile_statement")
  return_ref(res)  
endfunction()
function(expr_compile_statements) # scope, ast
  map_tryget(${ast}  children)
  ans(statement_asts)
  set(statements)
  #message("children: ${statement_asts}")
  foreach(statement_ast ${statement_asts})
    ast_eval(${statement_ast} ${context})
    ans(statement)
    set(statements "${statements}
  ${statement}")
  endforeach()
  map_tryget(${ast}  data)
  ans(data)
  make_symbol()
  ans(symbol)
  
 
  set(res "
  # expr_compile_statements
  ${statements}
  # end of expr_compile_statements")
#  message("${res}")
  return_ref(res)  
endfunction()
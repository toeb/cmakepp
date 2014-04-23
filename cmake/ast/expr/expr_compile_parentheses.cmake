function(expr_compile_parentheses)

  map_tryget(${ast} expression_ast children)
  
  ast_eval(${expression_ast} ${context})
  ans(expression)

  set(res "
  # expr_compile_parentheses
  ${expression}
  # end of expr_compile_parentheses")


  return_ref(res)
endfunction()
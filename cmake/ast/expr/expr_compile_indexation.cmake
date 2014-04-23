function(expr_compile_indexation)
  map_tryget(${ast} indexation_expression_ast children)
  
  ast_eval(${indexation_expression_ast} ${context})
  ans(indexation_expression)

  set(res "
  # expr_compile_indexation
  ${indexation_expression}
  ans(index)
  set(this \"\${left}\")
  map_get(\"\${this}\" trash \"\${index}\")
  # end of expr_compile_indexation")


  return_ref(res)
endfunction()
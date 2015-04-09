
function(expr_parse type arguments)
  
  set(argn "${ARGN}")
  arguments_expression_parse_cached("${type}" "${arguments}" "argn" 2 ${ARGC})
  return_ans()
endfunction()


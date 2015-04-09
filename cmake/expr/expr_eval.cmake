
function(expr_eval type arguments)
  set(argn "${ARGN}")
  arguments_expression_eval_cached("${type}" "${arguments}" argn 2 ${ARGC})
  rethrow()
endfunction()

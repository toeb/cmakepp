
function(compile_expr2 func_name type)
  expression("${type}" ${ARGN})
  ans(context)
  map_tryget("${context}" result)
  ans(result)
  #print_vars(result)
  map_tryget("${result}" code)
  ans(code)
  map_tryget("${result}" argument)
  ans(argument)

  set(code "macro(${func_name})\n${code}set(__ans ${argument})\nendmacro()\n")
 # message("${code}")
 #_message("${code}")
  eval("${code}")
endfunction()


function(arguments_compile_expr2_cached func_name type arguments)
  string(MD5 "_expr_${func_name}${type}${arguments}${ARGN}" cache_key)

  arguments_expression("${type}" "${arguments}" 3 ${ARGC})
  ans(context)


  map_tryget("${context}" result)
  ans(result)
  map_tryget("${result}" code)
  ans(code)
  map_tryget("${result}" argument)
  ans(argument)

  set(code "macro(${func_name})\n${code}set(__ans ${argument} PARENT_SCOPE)\nendmacro()\n")
  eval_ref(code)

endfunction()

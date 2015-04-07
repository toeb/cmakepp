
macro(arguments_expression type arguments start end)
  arguments_create_tokens("${start}" "${end}")
  ans(tokens)
  map_new()
  ans(context)
  map_set(${context} current_id 0)
 

  eval("${type}(\"${tokens}\" ${arguments})")
  rethrow()
  map_set(${context} result "${__ans}")
  set(__ans ${context})
endmacro()
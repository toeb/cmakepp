## interpret an lvalue
## needs a rvalue
function(interpret_scope_lvalue tokens rvalue)
  list_select_property(tokens type)
  ans(types)

  if(NOT "${types}" MATCHES "^dollar;(unquoted|paren)$")
    return()
  endif()

  list(GET tokens 1 lvalue)

  interpret_literal("${lvalue}")
  ans(lvalue)

  map_tryget("${rvalue}" argument)
  ans(rvalue_argument)


  map_tryget("${lvalue}" argument)
  ans(argument)

  set(code "set(${argument} ${rvalue_argument} PARENT_SCOPE)\n")


  map_new()
  ans(ast)
  map_set(${ast} type lvalue)
  map_set(${ast} argument "${rvalue_argument}")
  map_set(${ast} code "${code}")
  map_set(${ast} tokens ${tokens})
  return(${ast})
endfunction()
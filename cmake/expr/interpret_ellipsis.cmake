
function(interpret_ellipsis tokens)
  set(dots)
  list_pop_back(tokens)
  ans_append(dots)
  list_pop_back(tokens)
  ans_append(dots)
  list_pop_back(tokens)
  ans_append(dots)

  list_select_property(dots type)
  ans(dot_types)

  if(NOT "${dot_types}" STREQUAL "dot;dot;dot")
    list(REVERSE dot_types)
    throw("not ellipsis: ${dot_types}")
  endif()

  if(NOT tokens)
    throw("no left hand rvalue")
  endif()

  interpret_rvalue("${tokens}")
  rethrow()
  ans(rvalue)




  map_tryget("${rvalue}" ref)
  ans(rvalue_ref)

  map_tryget("${rvalue}" value_type)
  ans(rvalue_value_type)

  map_tryget("${rvalue}" value)
  ans(rvalue_value)

  map_tryget("${rvalue}" static)
  ans(rvalue_static)




  ast_new(
    "${tokens}"
    ellipsis
    "${rvalue_value_type}"
    "${rvalue_ref}"
    ""
    "${rvalue_value}"
    "${rvalue_static}"
    "${rvalue}"
    )
  ans(ast)
  return_ref(ast)
endfunction()
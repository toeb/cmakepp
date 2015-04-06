
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

  map_tryget("${rvalue}" code)
  ans(rvalue_code)

  map_tryget("${rvalue}" argument)
  ans(rvalue_argument)




  map_new()
  ans(ast)
  map_set("${ast}" type ellipsis)
  map_set("${ast}" rvalue "${rvalue}")
  map_set("${ast}" code "${code}")
  map_set("${ast}" argument "${argument}")
  return_ref(ast)
endfunction()
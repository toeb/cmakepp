
function(interpret_indexation tokens)
  list_pop_back(tokens)
  ans(bracket)
  if(NOT tokens OR NOT bracket)
    return()
  endif()

  map_tryget("${bracket}" type)
  ans(type)

  if(NOT "${type}" STREQUAL "bracket")
    return()
  endif()

  interpret_rvalue("${tokens}")
  ans(rvalue)

  if(NOT rvalue)
    return()
  endif()

  map_tryget("${rvalue}" argument)
  ans(rvalue_argument)

  map_tryget("${rvalue}" code)
  ans(rvalue_code)


  next_id()
  ans(id)


  map_tryget("${}")

  set(code "set(${id})\n")


  map_new()
  ans(ast)
  map_set("${ast}" type indexation)
  map_set("${ast}" code "${code}")
  map_set("${ast}" argument "\${${id}}")
  return_ref(ast)
endfunction()


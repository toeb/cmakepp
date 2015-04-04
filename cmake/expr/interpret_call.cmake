
function(interpret_call tokens)
  if(NOT tokens)
    return()
  endif()
  
  list_pop_back(tokens)
  ans(paren)

  if(NOT tokens)
    return()
  endif()


  map_tryget("${paren}" type)
  ans(type)

  if(NOT "${type}" STREQUAL "paren")
    return()
  endif()

  interpret_rvalue("${tokens}")
  ans(rvalue)



  map_tryget("${rvalue}" argument)
  ans(rvalue_argument)

  map_tryget("${rvalue}" code)
  ans(rvalue_code)

  map_tryget("${rvalue}" static)
  ans(rvalue_is_static)


  interpret_paren("${paren}")
  ans(parameters)

  map_tryget("${parameters}" code)
  ans(parameter_code)

  map_tryget("${parameters}" argument)
  ans(parameter_argument)


  
  next_id()
  ans(id)



  set(code "${rvalue_code}${parameter_code}")
  if(rvalue_is_static)
    set(code "${code}\n${rvalue_argument}(${parameter_argument})\n")
  else()
    set(code "${code}\neval(\"${rvalue_argument}(${parameter_argument})\")\n")
  endif()
  set(code "${code}set(${id} \${__ans})\n")


  #print_vars(in_call code rvalue_code parameter_code)
  map_new()
  ans(ast)

  map_set("${ast}" type call)
  map_set("${ast}" argument "\${${id}}")
  map_set("${ast}" code "${code}")


  return(${ast})
endfunction()
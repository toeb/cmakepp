
function(interpret_call tokens)
  if(NOT tokens)
    throw("no tokens specified" --function interpret_call)
  endif()
  
  list_pop_back(tokens)
  ans(paren)


  map_tryget("${paren}" type)
  ans(type)

  if(NOT "${type}" STREQUAL "paren")
    throw("no value for left hand side" --function interpret_call)
  endif()


  if(NOT tokens)
    throw("no value for left hand side" --function interpret_call)
  endif()



  interpret_rvalue("${tokens}")
  ans(rvalue)
  if(NOT rvalue)
    throw("could not parse rvalue" --function interpret_call)
  endif()



  map_tryget("${rvalue}" argument)
  ans(rvalue_argument)

  map_tryget("${rvalue}" code)
  ans(rvalue_code)

  map_tryget("${rvalue}" static)
  ans(rvalue_is_static)


  interpret_paren("${paren}")
  ans(parameters)


  map_tryget("${parameters}" code)
  ans(parameters_code)

  map_tryget("${parameters}" elements)
  ans(parameter_rvalues)


  set(invocation_arguments)
  foreach(parameter_rvalue ${parameter_rvalues})
    map_tryget("${parameter_rvalue}" type)
    ans(parameter_rvalue_type)
    
    if("${parameter_rvalue_type}" STREQUAL "ellipsis")
      map_tryget("${parameter_rvalue}" rvalue)      
      ans(parameter_rvalue)
      map_tryget("${parameter_rvalue}" argument)
      ans(parameter_rvalue_argument)
      set(invocation_arguments "${invocation_arguments} ${parameter_rvalue_argument}")


    else()
      map_tryget("${parameter_rvalue}" argument)
      ans(parameter_rvalue_argument)
      if(rvalue_is_static)
        set(invocation_arguments "${invocation_arguments} \"${parameter_rvalue_argument}\"")
      else()
        set(invocation_arguments "${invocation_arguments} \\\"${parameter_rvalue_argument}\\\"")

      endif()
    endif()



  endforeach()
  if(invocation_arguments)
    string(SUBSTRING "${invocation_arguments}" 1 -1 invocation_arguments)
  endif()

next_id()
ans(id)
  set(code "${rvalue_code}${parameters_code}")
  if(rvalue_is_static)
    set(code "${code}\n${rvalue_argument}(${invocation_arguments})\n")
  else()

    set(code "${code}\neval(\"${rvalue_argument}(${invocation_arguments})\")\n")
  endif()
  set(code "${code}set(${id} \${__ans})\n")


  #message("${code}")


  #print_vars(in_call code rvalue_code parameters_code)
  map_new()
  ans(ast)

  map_set("${ast}" type call)
  map_set("${ast}" argument "\${${id}}")
  map_set("${ast}" code "${code}")


  return(${ast})
endfunction()

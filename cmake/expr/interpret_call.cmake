
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



  map_tryget("${rvalue}" value)
  ans(rvalue_value)

  map_tryget(${paren} tokens)
  ans(call_tokens)

  interpret_elements("${call_tokens}" "comma" "interpret_ellipsis;interpret_expression")
  ans(parameters) 

  set(parameters_code)


  set(parameters_string)
  foreach(parameter ${parameters})

    map_tryget("${parameter}" expression_type)
    ans(parameter_expression_type)

    if("${parameter_expression_type}" STREQUAL "ellipsis")
      map_tryget("${parameter}" children)
      ans(parameter)
      map_tryget("${parameter}" value)
      ans(parameter_value)
      set(parameters_string "${parameters_string} ${parameter_value}")
    else()
      map_tryget("${parameter}" value)
      ans(parameter_value)
      set(parameters_string "${parameters_string} \\\"${parameter_ref}\\\"")
    endif()   
  endforeach()

  ## remove initial space
  if(parameters)
    string(SUBSTRING "${parameters_string}" 1 -1 parameters_string)
  endif()


  next_id()
  ans(ref)

  set(code "eval(\"${rvalue_value}(${parameters_string})\")\nans(${ref})\n")
    
  ast_new(
    "${tokens}"
    call
    any
    "${ref}"
    "${code}"
    "\${${ref}}"
    false
    "${rvalue};${parameters}"
    )
  ans(ast)


  return_ref(ast)


endfunction()

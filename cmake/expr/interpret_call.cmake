
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

  map_tryget("${rvalue}" const)
  ans(rvalue_is_const)

  map_tryget(${paren} tokens)
  ans(call_tokens)

  interpret_elements("${call_tokens}" "comma" "interpret_ellipsis;interpret_expression")
  ans(parameters) 

  set(parameters_string)
  foreach(parameter ${parameters})

    map_tryget("${parameter}" expression_type)
    ans(parameter_expression_type)
    #print_Vars(parameter.expression_type parameter.value)
    if("${parameter_expression_type}" STREQUAL "ellipsis")
      map_tryget("${parameter}" children)
      ans(parameter)
      map_tryget("${parameter}" value)
      ans(parameter_value)
      set(parameters_string "${parameters_string} ${parameter_value}")
    else()
      map_tryget("${parameter}" value)
      ans(parameter_value)
      set(parameters_string "${parameters_string} \"${parameter_value}\"")
    endif()   
  endforeach()

  ## remove initial space
  if(parameters)
    string(SUBSTRING "${parameters_string}" 1 -1 parameters_string)
  endif()


  next_id()
  ans(ref)

  if(rvalue_is_const)
    set(code "${rvalue_value}(${parameters_string})\nans(${ref})\n")
  else()

function(cmake_string_escape3 str)
  if("${str}" MATCHES "[ \"\\(\\)#\\^\t\r\n\\]")
    ## encoded list encode cmake string...
    #string(REPLACE "\\" "\\\\" str "${str}")
    string(REGEX REPLACE "([ \"\\(\\)#\\^])" "\\\\\\1" str "${str}")
    string(REPLACE "\t" "\\t" str "${str}")
    string(REPLACE "\n" "\\n" str "${str}")
    string(REPLACE "\r" "\\r" str "${str}")  
  endif()
  return_ref(str)
endfunction()

    cmake_string_escape3("${parameters_string}")
    ans(parameters_string)
   # _message("${parameters_string}")
    set(code "eval(\"${rvalue_value}(${parameters_string})\")\nans(${ref})\n")
  endif()
  ast_new(
    "${tokens}"
    call
    any
    "${ref}"
    "${code}"
    "\${${ref}}"
    false
    false
    "${rvalue};${parameters}"
    )
  ans(ast)


  return_ref(ast)


endfunction()

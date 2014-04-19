function(expr_eval_cmake_identifier)
  #message("cmake_identifier")
  #ref_print(${ast})
  map_get(${ast} identifier children)
  map_get(${identifier} identifier data)

  if(NOT "${identifier}" AND COMMAND "${identifier}")
    
  else()
    set(identifier "${${identifier}}")
  endif()
#  message("returning ${identifier}")
  return_ref(identifier)
endfunction()
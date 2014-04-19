function(expr_compile_cmake_identifier)
  #message("cmake_identifier")
  #ref_print(${ast})
  map_get(${ast} identifier children)
  map_get(${identifier} identifier data)

 

 # make_symbol()
#ans(symbol)

#  map_append_string(${context} code "
#function(${symbol})
#  #message(\"evaluating cmake identifier ${identifier}:\${${identifier}}\")
#  if(DEFINED ${identifier})
#    return_ref(${identifier})
#  endif()  
#  if(COMMAND ${identifier})
#    return(${identifier})
#  endif()
#endfunction()")

#  message("returning ${identifier}")
  set(res "
  #expr_compile_cmake_identifier
  set_ans_ref(${identifier})
  # end of expr_compile_cmake_identifier")
  return_ref(res)
endfunction()
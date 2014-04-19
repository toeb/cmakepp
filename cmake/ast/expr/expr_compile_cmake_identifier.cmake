function(expr_compile_cmake_identifier)
  #message("cmake_identifier")
  #ref_print(${ast})
  map_get(${ast} identifier children)
  map_get(${identifier} identifier data)
  
  set(res "
  #expr_compile_cmake_identifier
  set_ans_ref(${identifier})
  # end of expr_compile_cmake_identifier")
  return_ref(res)
endfunction()
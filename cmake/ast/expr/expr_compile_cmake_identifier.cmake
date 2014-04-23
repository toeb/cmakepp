function(expr_compile_cmake_identifier)
  #message("cmake_identifier")
  #ref_print(${ast})
  map_get(${ast}  children)
  ans(identifier)
  map_get(${identifier}  data)
  ans(identifier)
  
  set(res "
  #expr_compile_cmake_identifier
  set_ans_ref(${identifier})
  # end of expr_compile_cmake_identifier")
  return_ref(res)
endfunction()
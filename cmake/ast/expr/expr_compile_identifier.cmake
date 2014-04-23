function(expr_compile_identifier)# ast context
  
#message("ast: ${ast}")

  map_tryget(${ast}  data)
  ans(data)
  set(res "
  # expr_compile_identifier
  obj_get(\"\${this}\" trash \"${data}\")
  # end of expr_compile_identifier")
  return_ref(res)
endfunction()
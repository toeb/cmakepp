## returns the list element at the specified 
## 0 based index if the index is negative 
## the element counted from back is returned
function(list_at  lst idx)
  list(LENGTH ${lst} len)
  if(${idx} LESS 0)
    math(EXPR idx "${len} ${idx}")
  endif()
  list(GET ${lst} ${idx} value)
  return_ref(value)
endfunction()
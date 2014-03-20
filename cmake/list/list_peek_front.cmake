
function(list_peek_front result lst)
  if(NOT "${lst}")
    return_value()
  endif()
  list(GET "${lst}" 0 res)
  set(${result} ${res} PARENT_SCOPE)
endfunction()
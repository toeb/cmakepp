
function(list_peek_front result __list_peek_front_lst)
  if(NOT DEFINED "${__list_peek_front_lst}")
    return_value()
  endif()
  list(GET "${__list_peek_front_lst}" 0 res)
  set(${result} ${res} PARENT_SCOPE)
endfunction()
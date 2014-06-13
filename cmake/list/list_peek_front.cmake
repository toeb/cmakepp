# gets the first element of the list
function(list_peek_front __list_peek_front_lst)
  if(NOT DEFINED "${__list_peek_front_lst}")
    return()
  endif()
  list(GET "${__list_peek_front_lst}" 0 res)
  return_ref(res)
endfunction()
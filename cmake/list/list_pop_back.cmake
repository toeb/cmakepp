# removes the last element from list and returns it
function(list_pop_back __list_pop_back_lst)

  if(NOT DEFINED ${__list_pop_back_lst})
    return()
  endif()
  list(LENGTH ${__list_pop_back_lst} len)
  math(EXPR len "${len} - 1")
  list(GET ${__list_pop_back_lst} "${len}" res)
  list(REMOVE_AT ${__list_pop_back_lst} ${len})
  set(${__list_pop_back_lst} ${${__list_pop_back_lst}} PARENT_SCOPE)
  return_ref(res)
endfunction()
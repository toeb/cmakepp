
function(list_pop_back result __list_pop_back_lst)

  if(NOT DEFINED ${__list_pop_back_lst})
    return_value()
  endif()
  list(LENGTH ${__list_pop_back_lst} len)
  math(EXPR len "${len} - 1")
  list(GET ${__list_pop_back_lst} "${len}" res)
  list(REMOVE_AT ${__list_pop_back_lst} ${len})
  set(${result} ${res} PARENT_SCOPE)
  set(${__list_pop_back_lst} ${${__list_pop_back_lst}} PARENT_SCOPE)
endfunction()
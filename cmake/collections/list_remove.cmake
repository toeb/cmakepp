# removes all items specified in varargs from list
function(list_remove __list_remove_lst)
  list(LENGTH "${__list_remove_lst}" __lst_len)
  list(LENGTH ARGN __arg_len)
  if(__arg_len EQUAL 0 OR __lst_len EQUAL 0)
    return()
  endif()

  list(REMOVE_ITEM "${__list_remove_lst}" ${ARGN})
  set("${__list_remove_lst}" "${${__list_remove_lst}}" PARENT_SCOPE)
  return_ref("${__list_remove_lst}")
endfunction()
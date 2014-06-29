# removes all items specified in varargs from list
function(list_remove __list_remove_lst)
  if(NOT "${__list_remove_lst}" )
    return()
  endif()

  list(REMOVE_ITEM "${__list_remove_lst}" ${ARGN})
  set("${__list_remove_lst}" "${${__list_remove_lst}}" PARENT_SCOPE)
  return_ref("${__list_remove_lst}")
endfunction()
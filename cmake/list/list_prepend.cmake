# adds the varargs before the specified list
function(list_prepend __list_prepend_lst)
  set("${__list_prepend_lst}" ${ARGN} ${${__list_prepend_lst}})
  return()
endfunction()
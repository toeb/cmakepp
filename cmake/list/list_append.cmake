# appends all varags to specified list
function(list_append __list_append_lst)
  set("${__list_append_lst}" ${${__list_append_lst}} ${ARGN} PARENT_SCOPE)
  return()
endfunction()
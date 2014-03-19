
 function(list_rest  result)
  if(NOT ARGN)
    return_value()
  endif()
  set(args ${ARGN})
  list(REMOVE_AT args 0)
  set(${result} ${args} PARENT_SCOPE)
 endfunction()
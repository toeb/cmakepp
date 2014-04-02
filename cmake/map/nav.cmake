function(nav navigation_expression)
  set(args ${ARGN})
  if(NOT DEFINED args)
    map_navigate(res "${navigation_expression}")
    return(${res})
  endif()

  if("${ARGN}" STREQUAL "UNSET")
    map_navigate_set("${navigation_expression}")
    return()
  endif()


  set(args ${ARGN})
  list_peek_front(first args)
  
  if("_${first}" STREQUAL _FORMAT)
    list_pop_front(trash args)
    map_format(args "${args}")  
  endif()

  if("_${first}" STREQUAL _ASSIGN)
    list_pop_front(trash args)
  #  message("asd ${args} ")
    map_navigate(args "${args}")
  #  message("asd ${args} ")
  endif()
  # this is a bit hacky . if a new var is created by map_navigate_set
  # it is propagated to the PARENT_SCOPE
  string(REGEX REPLACE "^([^.]*)\\..*" "\\1" res "${navigation_expression}")
  map_navigate_set("${navigation_expression}" ${args})
  set(${res} ${${res}} PARENT_SCOPE)

  return_ref(args)
endfunction()
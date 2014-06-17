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
  list_peek_front( args)
  ans(first)
  
  if("_${first}" STREQUAL _FORMAT)
    list_pop_front( args)
    map_format( "${args}")  
    ans(args)
  endif()

  if("_${first}" STREQUAL _APPEND OR "_${first}" STREQUAL "_+=")
    list_pop_front(args)
    map_navigate(cur "${navigation_expression}")
    map_navigate(args "${args}")
    set(args ${cur} ${args})
  endif()

  if("_${first}" STREQUAL _REMOVE OR "_${first}" STREQUAL "_-=")
    list_pop_front(args)
    map_navigate(cur "${navigation_expression}")
    map_navigate(args "${args}")
    if(cur)
      list(REMOVE_ITEM cur "${args}")
    endif()
    set(args ${cur})
  endif()

  if("_${first}" STREQUAL _ASSIGN OR "_${first}" STREQUAL _= OR "_${first}" STREQUAL _*)
    list_pop_front( args)
    map_navigate(args "${args}")
  endif()


  if("_${first}" STREQUAL _CLONE_DEEP)
    list_pop_front( args)
    map_navigate(args "${args}")
    map_clone_deep("${args}")
    ans(args)
  endif()

  if("_${first}" STREQUAL _CLONE_SHALLOW)
    list_pop_front( args)
    map_navigate(args "${args}")
    map_clone_shallow("${args}")
    ans(args)
  endif()

  # this is a bit hacky . if a new var is created by map_navigate_set
  # it is propagated to the PARENT_SCOPE
  string(REGEX REPLACE "^([^.]*)\\..*" "\\1" res "${navigation_expression}")
  map_navigate_set("${navigation_expression}" ${args})
  set(${res} ${${res}} PARENT_SCOPE)

  return_ref(args)
endfunction()
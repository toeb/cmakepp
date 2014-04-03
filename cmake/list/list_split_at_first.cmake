
function(list_split_first first rest lst)
  if(DEFINED ${lst})
    set(${first} PARENT_SCOPE)
    set(${res} PARENT_SCOPE)
  endif()

  list(GET ${lst} 0 _first)
  list(REMOVE_AT ${lst} 0)

  set(${first} ${_first} PARENT_SCOPE)
  if(DEFINED ${lst})
    set(${rest} ${${lst}} PARENT_SCOPE)
  endif()
endfunction()
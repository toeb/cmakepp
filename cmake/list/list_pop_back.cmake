
function(list_pop_back result lst)

  if(NOT DEFINED ${lst})
    return_value()
  endif()
  list(LENGTH ${lst} len)
  math(EXPR len "${len} - 1")
  list(GET ${lst} "${len}" res)
  list(REMOVE_AT ${lst} ${len})
  set(${result} ${res} PARENT_SCOPE)
  set(${lst} ${${lst}} PARENT_SCOPE)
endfunction()
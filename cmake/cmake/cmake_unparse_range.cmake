
  function(cmake_unparse_range start)
    token_range("${start}" ${ARGN})
    ans(tokens)
    set(result)
    foreach(token ${tokens})
      map_tryget(${token} value)
      ans(value)
      set(result "${result}${value}")
    endforeach()

    return_ref(result)
  endfunction()

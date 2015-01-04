

  function(list_range_get lst)
    list(LENGTH ${lst} len)
    range_indices("${len}" ${ARGN})
    ans(indices)
    list(LENGTH indices len)
    if(NOT len)
      return()
    endif()
    list(GET ${lst} ${indices} res)
    return_ref(res)
  endfunction()

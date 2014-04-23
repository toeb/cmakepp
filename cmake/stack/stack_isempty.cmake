

  function(stack_isempty stack)
    ref_get(${stack} )
    ans(lst)
    list(LENGTH lst len)
    if(${len} EQUAL 0)
      return(true)
    endif()
    return(false)
  endfunction()
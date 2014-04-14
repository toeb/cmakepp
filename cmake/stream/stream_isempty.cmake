
  function(stream_isempty)
    ref_get(${stream} data)
    string(LENGTH "${data}" len)
    if(NOT len)
      return(true)
    endif()
    return(false)
  endfunction()
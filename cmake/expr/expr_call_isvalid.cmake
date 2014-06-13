
  function(expr_call_isvalid str)

    if("${str}" MATCHES "^.*\\(.*\\)$")
      return(true)
    endif()
    return(false)
  endfunction()
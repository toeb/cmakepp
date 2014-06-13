
  function(expr_integer_isvalid str)
  set(regex_integer "-?(0|([1-9][0-9]*))")
    if("${str}" MATCHES "^${regex_integer}$")
      return(true)
    endif()
    return(false)
  endfunction()

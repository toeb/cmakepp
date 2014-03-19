
 function(string_isnumeric result str)
    if("${str}" MATCHES "^[0-9]+$")
      return_value(true)
    endif()
      return_value(false)

 endfunction()
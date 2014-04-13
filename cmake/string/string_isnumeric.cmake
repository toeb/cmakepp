 function(string_isnumeric result str)
    if("_${str}" MATCHES "^_[0-9]+$")
      return_value(true)
    endif()
      return_value(false)

 endfunction()
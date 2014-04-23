
 function(string_isempty result str)
    
    if( "_" STREQUAL "_${str}" )
      return_value(true)
    endif()
    return_value(false)
 endfunction()
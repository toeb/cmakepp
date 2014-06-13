
 function(string_isempty  str)
    
    if( "_" STREQUAL "_${str}" )
      return(true)
    endif()
    return(false)
 endfunction()
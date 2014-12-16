## returns true if the given string is empty
## normally because cmake evals false, no,  
## which destroys tests for real emtpiness
##
##
 function(string_isempty  str)    
    if( "_" STREQUAL "_${str}" )
      return(true)
    endif()
    return(false)
 endfunction()
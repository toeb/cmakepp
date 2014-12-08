# returns the identifier for the os being used
function(os)
  if(WIN32)
    return(Windows)
  else()
    return(Unknown)
  endif()


endfunction()

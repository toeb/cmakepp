## returns true if the string is a integer (number)
## does not match non integers
function(string_isnumeric str)
  if("_${str}" MATCHES "^_[0-9]+$")
    return(true)
  endif()
  return(false)
endfunction()
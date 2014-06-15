
# evaluates the string against the regex
# and returns true iff it matches
function(string_match  str regex)
  if("${str}" MATCHES "${regex}")
    return(true)
  endif()
  return(false)
endfunction()
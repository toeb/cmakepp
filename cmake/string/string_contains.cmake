# returns true if ${str} contains ${search}
function(string_contains str search)
  string(FIND "${str}" "${search}" index)
  if("${index}" LESS 0)
    return(false)
  endif()
  return(true)
endfunction()
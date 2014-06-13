# creates a file or updates the file access time
# *by appending an empty string
function(touch path)
  path("${path}")
  ans(path)
  if(NOT EXISTS "${path}" )
    file(WRITE "${path}" "")
    return()
  endif()
  file(APPEND "${path}" "")
  return()
endfunction()
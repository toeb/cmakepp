
## returns the timestamp for the specified path
function(file_timestamp path)
  path("${path}")
  ans(path)

  if(NOT EXISTS "${path}")
    return()
  endif()

  file(TIMESTAMP "${path}" res)


  return_ref(res)
endfunction()
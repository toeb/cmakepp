# returns a list of files
# todo: http://ss64.com/bash/ls.html
function(ls)
  path("${ARGN}")
  ans(path)

  if(IS_DIRECTORY "${path}")
    set(path "${path}/*")
  endif()

  file(GLOB files "${path}")
  return_ref(files)
endfunction()

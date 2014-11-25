# creates a new directory
function(mkdir path)    
  path("${path}")
  ans(path)
  file(MAKE_DIRECTORY "${path}")
  return_ref(path)
endfunction()


function(mkdirs)
  set(res)
  foreach(path ${ARGN})
    mkdir("${path}")
    ans(p)
    list(APPEND res "${p}")    
  endforeach()
  return_ref(res)
endfunction()



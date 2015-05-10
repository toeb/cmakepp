
##
##
## returns a single file name to which the glob expression matches
## if the glob expression matches multiple files then nothing is returned
function(glob_single)
  glob(${ARGN})
  ans(found)


  list(LENGTH found len)
  if(${len} EQUAL 1)
    return_ref(found)
  endif()

  return()
endfunction()
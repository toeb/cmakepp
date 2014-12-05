# sleeps for the specified amount of seconds
function(sleep seconds)
  if("${CMAKE_MAJOR_VERSION}" LESS 3)
    message(WARNING "sleep no available in cmake version ${CMAKE_VERSION}")
    return()
  endif()
  cmake(-E sleep "${seconds}")
  return()
endfunction()
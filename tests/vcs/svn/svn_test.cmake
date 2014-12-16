function(test)

  find_package(Subversion)
  if(NOT SUBVERSION_FOUND)
    message("test inconclusive - subversion not isntalled")
    return()
  endif()

  
  svn(--version --quiet --result)  
  ans(res)

  json_print(${res})


  map_tryget(${res} output)
  ans(res)
  string(STRIP "${res}" res)

  assert("${res}" STREQUAL "${Subversion_VERSION_SVN}")


endfunction()




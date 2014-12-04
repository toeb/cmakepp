function(test)

  find_package(Subversion)
  if(NOT SUBVERSION_FOUND)
    message("test inconclusive - subversion not isntalled")
    return()
  endif()

  
  svn(--version --quiet)
  ans(res)
  message("${res}")
  string(STRIP "${res}" res)
  assert("${res}" STREQUAL "${Subversion_VERSION_SVN}")


endfunction()




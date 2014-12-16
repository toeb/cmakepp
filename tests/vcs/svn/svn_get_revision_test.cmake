function(test)

  find_package(Subversion)
  if(NOT SUBVERSION_FOUND)
    message("test inconclusive svn not installed")
    return()
  endif()

  svn_info("http://llvm.org/svn/llvm-project/llvm/trunk")
  ans(res)
  json_print(${res})
  assert(res)

  svn_get_revision("http://llvm.org/svn/llvm-project/llvm/trunk")
  ans(res)
  message("${res}")
  assert(res)

endfunction()
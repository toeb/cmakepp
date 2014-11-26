function(test)

  svn_info("http://llvm.org/svn/llvm-project/llvm/trunk")
  ans(res)
  json_print(${res})
  assert(res)

  svn_get_revision("http://llvm.org/svn/llvm-project/llvm/trunk")
  ans(res)
  message("${res}")
  assert(res)

endfunction()
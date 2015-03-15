function(test)

  
    
  cmake_rename_function("  function(asd) \n endfunction()" "asd" "bsd")
  ans(res)
  assert("${res}" STREQUAL "  function(bsd) \n endfunction()")



  cmake_rename_function("  function(asd) \n function(ksd)\nendfunction() \n endfunction()" "asd.ksd" "bsd")
  ans(res)
  assert("${res}" STREQUAL "  function(asd) \n function(bsd)\nendfunction() \n endfunction()")




endfunction()
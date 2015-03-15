function(test)




  cmake_set_variable(" function(asd) \n set(var1 a b c d) \n endfunction()" "asd.var1" " hello world")
  ans(res)
  assert("${res}" STREQUAL " function(asd) \n set(var1 hello world) \n endfunction()")

  cmake_set_variable("set(var1)" "var1" " hello world")
  ans(res)
  assert("${res}" STREQUAL "set(var1 hello world)")


endfunction()
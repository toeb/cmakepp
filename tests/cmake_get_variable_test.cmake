function(test)


  cmake_get_variable(" function(asd) \n set(var1 a b c d) \n endfunction()" "asd.var1")
  ans(res)
  assert("${res}" STREQUAL " a b c d")

  cmake_get_variable("set(the_var asdasdasd)" "the_var")
  ans(res)
  assert("${res}" STREQUAL " asdasdasd")
  
  cmake_get_variable("set(empty_var)" "empty_var")
  ans(res)
  assert("${res}_" STREQUAL "_")



return()
  message("${res}")

  return(0)

  cmake_set_variable(" function(asd) \n set(var1 a b c d) \n endfunction()" "asd.var1" " hello world")
  ans(res)
  message("${res}")


return()
  cmake_rename_function("  function(asd) \n endfunction()" "asd" "bsd")
  ans(res)

  message("${res}")

  

endfunction()
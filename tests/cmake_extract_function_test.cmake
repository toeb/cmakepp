function(test)


  function(lolfunction)
      # this is just a test
  endfunction()

 cmake_extract_function("function(test1)\nendfunction() \nfunction(test2)\nendfunction()   " "test2")
 ans(res)
 assert("${res}" STREQUAL "function(test2)\nendfunction()")


  cmake_extract_function("function(test1)\nfunction(test2)\nendfunction()\nendfunction()" test1.test2)
  ans(res)
  assert("${res}" STREQUAL "function(test2)\nendfunction()")


  # fread("${CMAKE_CURRENT_LIST_FILE}")
  # ans(data)
  # cmake_extract_function("${data}" test.lolfunction)
  # ans(res)


  # message("${res}")

endfunction()
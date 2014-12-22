function(test)
  

  if(WIN32)
    path_relative("c:/test" "e:/test3")
    ans(res)
    assert("${res}" STREQUAL "e:/test3")

    
    path_relative("c:/test1/test3" "c:/test1/test2/test3" )
    ans(res)
    assert("${res}" STREQUAL "../test2/test3") 
  endif()




  mkdir(test1)
  mkdir(test2)
  mkdir(test1/test3)

  path_relative(test1 test2)
  ans(res)
  assert("${res}" STREQUAL "../test2")

  path_relative("test1/test3" test2)
  ans(res)
  assert("${res}" STREQUAL "../../test2")


endfunction()
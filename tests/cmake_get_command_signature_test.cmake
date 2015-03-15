function(test)






  cmake_get_invocations("asd(k a d f e f)" asd 1)
  ans(invocation)
  cmake_invocation_set_arguments(${invocation}
   a b c
    )

  cmake_unparse_range(${invocation})
  ans(res)
  message("${res}")



  cmake_get_invocations("function(test a b c)\nasd()\nendfunction()" "function")
  ans(res)
  assert(${res} COUNT 1)


  cmake_get_invocations("asd()\nbsd()\ncsd()\nksd()" "[ab]sd")
  ans(res)
  assert(${res} COUNT 2)

  cmake_get_invocations("asd()\nbsd()\ncsd()\nksd()" "[ab]sd" 1)
  ans(res)
  assert(${res} COUNT 1)

  cmake_get_invocations("asd()\nbsd()\ncsd()" ".*")
  ans(res)
  assert("${res}" COUNT 3)


  cmake_get_invocations("asd(1 2 3)\nbsd(2 3 4)\ncsd (5 6 7)" "bsd" 1)
  ans(invocation)
  cmake_invocation_get_arguments("${invocation}")
  ans(res)
  assert("${res}" STREQUAL "2 3 4")





endfunction()
function(test)
  # simple call void => void 
  function(fu)
  return()
  endfunction()

  function_call(fu())
  ans(res)
  assert(NOT res)


  # return value void => value
  function(fu1)
    return("myvalue")
  endfunction()

  function_call(fu1())
  ans(res)
  assert("${res}" STREQUAL "myvalue")

  # value => value
  function(fu2 arg)
    return("${arg}${arg}")
  endfunction()

  function_call(fu2(1))
  ans(res)
  assert("${res}" STREQUAL "11")

  # value , value => value
  function(fu3 arg1 arg2)
  return("${arg2}${arg1}")
  endfunction()

  function_call(fu3(12 34))
  ans(res)
  assert("${res}" STREQUAL "3412")

  # variable function name void => value
  function(myfu arg1 arg2)
  return("${arg2}${arg1}")
  endfunction()
  set(var myfu)

  function_call(${var}(12 34))
  ans(res)
  assert("${res}" STREQUAL "3412")


  # imported function
  function_call("function(fruhu arg)\nreturn(\${arg}\${arg})\nendfunction()"(ab))
  ans(res)
  assert("${res}" STREQUAL "abab")

  # lambda function
  function_call("()->message(hello)"())

  # 
  function_call("()->return(muuu)"())
  ans(res)
  assert("${res}" STREQUAL "muuu")

  # 
  set(myfuncyvar "()->return(mewto)")
  function_call(myfuncyvar())
  ans(res)
  assert("${res}" STREQUAL "mewto")

  #
  function(fu5)
    return("mewthree")
  endfunction()
  set(myfuncyvar fu5)
  function_call(myfuncyvar())
  ans(res)
  assert("${res}" STREQUAL "mewthree")




  nav(my.test.object "()->return(mewfour)")
  function_call(my.test.object())
  ans(res)
  assert("${res}" STREQUAL "mewfour")



endfunction()
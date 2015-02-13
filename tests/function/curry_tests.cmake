function(test)

  curry3(invocation_argument_string)
  ans(res)
  call("${res}"(1 2 3))
  ans(res)
  assert("${res}" STREQUAL "1 2 3")

  curry3(invocation_argument_string( 2 3 /1))
  ans(res)
  call("${res}"(a b c))
  ans(res)
  assert("${res}" STREQUAL "2 3 b")


    curry3((a b c) => invocation_argument_string(/c /b /a))
    ans(res)
  call("${res}"(1 2 3))
  ans(res)
  assert("3 2 1" STREQUAL "${res}")

  curry3( myfunc(a b c) => invocation_argument_string("ab;c" /* /c))
  ans(res)

  myfunc(1 2 3 4 5)
  ans(res)
  assert("${res}" EQUALS "\"ab;c\" 4 5 3")

  function(test_curry )
    return(${a} ${b} ${c} ${ARGN})
  endfunction()
  set(a 123)
  set(b 234)
  set(c 345)
  curry3(myfunc(a b c) => [a;b] test_curry(/3 /4 /4 /a /c /b "1;2;3" /*))

  set(a 456)
  set(c 567)

  myfunc(9 8 7 p o i)
  ans(res)
  assert(${res} EQUALS 123 234 567 p o o 9 7 8 1 2 3 p o i)

# takes about 30 ms per curry call
  timer_start(curry_compile_100)
  foreach(i RANGE 0 100)
      curry3(myfunc(a b c) => invocation_argument_string("ab;c" /* /c) )
  endforeach()
  timer_print_elapsed(curry_compile_100)


  timer_start(curry_compile_100)

  foreach(i RANGE 0 100)
      curry(invocation_argument_string(/2 33 /1 44) as myfunc)
  endforeach()
  timer_print_elapsed(curry_compile_100)

  return()


  curry3([a;b;c] string_length(/c /b /a) => myfunc(a b c))
  ans(res)

  curry3([a;b;c] "[](a)message({{a}})" (/c /b /a) => myfunc(a b c))
  ans(res)

  curry3(string_length("a;b;c;d") => myfunc(a b c))
  ans(res)



endfunction()
function(test)
 
return()
  map_navigate_set("qwe.asd" 0)
  map_navigate(res "qwe.asd")
  assert(qwe)
  assert("${res}" STREQUAL 0)


  nav(asd.b "test")
  assert(asd)
  
  nav(asd.b)
  ans(val)
  assert("${val}" STREQUAL "test")

  nav(bsd.x "0")
  ans(res)
  assert("${res}" STREQUAL "0")


  # navigate non existing value
  nav("a.v.x")
  ans(res)
  assert(NOT res )  

  # set value returns new value
  nav("a.v.x" hello)
  ans(res)
  assert("${res}" STREQUAL hello)

  # get set value
  nav("a.v.x")
  ans(res)
  assert("${res}" STREQUAL hello)

  # unset value
  nav("a.v.x" UNSET)
  ans(res)
  assert(NOT res)

  # get unset value
  nav("a.v.x")
  ans(res)
  assert(NOT res)

  # set value by another navigation expression
  nav("a.b.c" "h1")
  nav("a.v.x" ASSIGN "a.b.c")
  ans(res)
  assert("${res}" STREQUAL "h1")
  nav("a.v.x")
  ans(res)
  assert("${res}" STREQUAL "h1")
  nav("a.b.c")
  ans(res)
  assert("${res}" STREQUAL "h1")

  # set value by format string
  nav("a.v.x" FORMAT "{a.v.x}-{a.b.c}")
  ans(res)
  assert("${res}" STREQUAL "h1-h1")
endfunction()
function(test)



  json2("true")
  ans(res)
  assert("${res}" STREQUAL "true")


  json2("\"hello world\"")
  ans(res)
  assert("${res}" STREQUAL "hello world")
  
  json2("3123")
  ans(res)
  assert("${res}" STREQUAL "3123")


  json2("false")
  ans(res)
  assert("${res}" STREQUAL "false")

  

  json2("{}")
  ans(res)
  map_isvalid(${res})
  ans(ismap)
  assert(ismap)

  json2("{\"a\":\"b\"}")
  ans(res)
  assert(DEREF "{res.a}" STREQUAL "b")

  json2("{\"a\":\"a\",\"b\":\"b\"}")
  ans(res)  
  assert(DEREF "{res.a}" STREQUAL "a")
  assert(DEREF "{res.b}" STREQUAL "b")

return()
  json2("[1,2]")
  ans(res)
  assert(EQUALS 1 2 ${res})

  json2("[ 1,  2 ]")
  ans(res)
  assert(EQUALS 1 2 ${res})

endfunction()
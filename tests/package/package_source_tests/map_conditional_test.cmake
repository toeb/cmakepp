function(test)





  data("")
  ans(param)
  data("{'a':{'$if':'false', 'b':'c'}}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(res)
  assertf("{res.a.b}_" STREQUAL "_")



  data("")
  ans(param)
  data("{'a':{'$if':'true', 'b':'c'}}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(res)

  assertf("{res.a.b}" STREQUAL "c")



  data("")
  ans(param)
  data("{'a':{'$if':'true', '$then':'a', '$else':'b'}}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(res)

  assertf("{res.a}" STREQUAL "a")





  data("")
  ans(param)
  data("{'a':{'$if':'true', '$then':'a', '$else':'b'}}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(res)

  assertf("{res.a}" STREQUAL "a")


  data("")
  ans(param)
  data("{'a':{'$if':'false', '$then':'a', '$else':'b'}}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(res)

  assertf("{res.a}" STREQUAL "b")


  data("")
  ans(param)
  data("{'a':'a'}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(res)
  assertf("{res.a}" STREQUAL "a")



  data("")
  ans(param)
  data("")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(result)
  assert("${result}_" STREQUAL "_")


  data("")
  ans(param)
  data("{'$if':'true', '$then':'1', '$else':'2'}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(result)
  assert("${result}" STREQUAL "1")


  data("")
  ans(param)
  data("{'$if':'false', '$then':1, '$else':2}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(result)
  assert("${result}" STREQUAL "2")


  data("")
  ans(param)
  data("{'$if':'false', '$then':1, '$else':2}")
  ans(map)
  map_conditional_evaluate("${param}" ${map})
  ans(result)
  assert("${result}" STREQUAL "2")


endfunction()
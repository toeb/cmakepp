function(test)


  data("{a:'abc'}")
  ans(scope)
  data("{a:'@a'}")
  ans(data)
  map_template_evaluate_scoped("${scope}" ${data})
  ans(res)
  assertf({res.a} STREQUAL "abc")



  data("{a:'abc'}")
  ans(scope)
  data("{a:'@a'}")
  ans(data)
  map_template_evaluate_scoped("${scope}" ${data})
  ans(res)
  assertf({res.a} STREQUAL "abc")


  

  data("{a:'abc'}")
  ans(scope)
  data("{a:'@a'}")
  ans(data)
  map_template_evaluate_scoped("${scope}" ${data})
  ans(res)
  assertf({res.a} STREQUAL "abc")



  data("{}")
  ans(scope)
  data("simple")
  ans(data)
  map_template_evaluate_scoped("${scope}" ${data})
  ans(res)
  assertf({res} STREQUAL "simple")



  data("{a:'hello'}")
  ans(scope)
  data("simpletemplate@a")
  ans(data)
  map_template_evaluate_scoped("${scope}" ${data})
  ans(res)
  assertf({res} STREQUAL "simpletemplatehello")





endfunction()
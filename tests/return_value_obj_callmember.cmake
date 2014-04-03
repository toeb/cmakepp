function(test)
  
  function(TheTestClass)

    proto_declarefunction(method)
    function(${method})

      return(hello)
    endfunction()
  endfunction()


  obj_new(uut TheTestClass)
  obj_callmember(${uut} method)
  ans(res)

  assert(${res} STREQUAL "hello")

endfunction()
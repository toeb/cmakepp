function(test)
  
  function(TheTestClass)

    proto_declarefunction(method)
    function(${method})

      return(hello)
    endfunction()
  endfunction()


  obj_new( TheTestClass)
  ans(uut)
  obj_callmember(${uut} method)
  ans(res)

  assert(${res} STREQUAL "hello")

endfunction()
function(test)
return()
  function(Handler)

  endfunction()

  function(Pipeline)
    this_inherit(Handler)

    map_new()
    ans(filters)
    this_set(filters ${filters})

    map_new()
    ans(handlers)
    this_set(handlers ${handlers})


    proto_declarefunction(addFilter)
    function(${addFilter} filter)

    endfunction()


    proto_declarefunction(addHandler)
    function(${addHandler} handler)

    endfunction()


  endfunction()



  function(DelegatingHandler handler)
    this_set(handler ${handler})
    this_set(innerHandler)

    this_declarecalloperation(op)
    function(${op})
      this_get(handler)
      if(handler)
        call(${handler}(${ARGN}))
        ans(res)  
      endif()

    endfunction()



    proto_declarefunction(delegate)
    function(${delegate})

    endfunction()
  endfunction()


  obj_new(Pipeline)
  ans(pipeline)





endfunction()
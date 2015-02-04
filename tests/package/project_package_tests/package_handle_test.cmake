function(test)

  mkdir(p1)
  fwrite_data(p2/package.cmake "{custom_var:'custom_val'}" --json)

  package_handle("p1" "{id:'asd'}")
  ans(res)
  assert(res)
  assertf({res.package_descriptor.id} STREQUAL "asd")


  package_handle("p2")
  ans(res)
  assert(res)
  assertf({res.package_descriptor.custom_var} STREQUAL "custom_val")



  
    

endfunction()
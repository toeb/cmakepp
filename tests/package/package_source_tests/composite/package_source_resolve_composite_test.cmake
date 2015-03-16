function(test)
  fwrite_data("source1/pkg1/package.cmake" "{id:'pkg1'}" --json)
  fwrite_data("source2/pkg2/package.cmake" "{id:'pkg2'}" --json)
  fwrite_data("source3/pkg3/package.cmake" "{id:'pkg3'}" --json)
  fwrite_data("source4/pkg4/package.cmake" "{id:'pkg4'}" --json)
  fwrite_data("source5/pkg5/package.cmake" "{id:'pkg5'}" --json)
  fwrite_data("source5/pkg6/package.cmake" "{id:'pkg6'}" --json)



  directory_package_source("source1" "source1")
  ans(source1)
  directory_package_source("source2" "source2")
  ans(source2)
  directory_package_source("source3" "source3")
  ans(source3)
  directory_package_source("source4" "source4")
  ans(source4)
  directory_package_source("source5" "source5")
  ans(source5)

  composite_package_source("mysource" ${source1} ${source2} ${source3} ${source4} ${source5})
  ans(uut)

  uri("")
  ans(uri)
  assign(res = uut.resolve(${uri}))
  assert(NOT res)


  assign(res = uut.resolve(pkg1))
  assert(res)
  assertf({res.package_descriptor.id} STREQUAL "pkg1")






endfunction()
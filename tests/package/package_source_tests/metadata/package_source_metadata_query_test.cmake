function(test)



  metadata_package_source(mymetadata) 
  ans(uut)


  assign(success = uut.add_package_descriptor("{ id:'pkg1'}"))
  assert(success)
  assign(success = uut.add_package_descriptor("{ id:'pkg2'}"))
  assert(success)

  assign(res = uut.query("."))
  assert(NOT res)

  assign(res = uut.query("pkg1"))
  assert(res)
  assert("${res}" STREQUAL "mymetadata:pkg1")  

  assign(res = uut.query("mymetadata:pkg1"))
  assert(res)
  assert("${res}" STREQUAL "mymetadata:pkg1")

  assign(res = uut.query("pkg1" --package-handle))
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "pkg1" )
  assertf("{res.uri}" STREQUAL "mymetadata:pkg1" )
  assertf("{res.query_uri}" STREQUAL "pkg1" )


  assign(res = uut.query("*"))
  assert(COUNT 2 ${res})


  assign(res = uut.resolve("*"))
  assert(NOT res)  

  assign(res = uut.resolve("pkg1"))
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "pkg1")


  assign(res = uut.resolve("asdasdasd"))
  ans(res)
  assert(NOT res)


  assign(success = uut.pull("asdasd"))
  assert(NOT success)


  assign(success = uut.pull("asdasd" dir1))
  assert(NOT success)
  assert(NOT EXISTS "${test_dir}/dir1")


  assign(success = uut.pull("pkg1" dir1))
  assert(success)
  assert(EXISTS "${test_dir}/dir1")


  fwrite_data("pkg3/package.cmake" "{}" --json)
  path_package_source()
  ans(path_source)

  assign(success = uut.push(${path_source} "pkg3"))
  assert(success)


  assign(success = uut.push("${path_source}" adsadsasd))
  assert(NOT success)




endfunction()
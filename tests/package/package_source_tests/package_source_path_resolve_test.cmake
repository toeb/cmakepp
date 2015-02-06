function(test)


  fwrite("test/asdasd/package.cmake" "{\"id\":\"mypkg\"}")
  mkdir("test/asdasd2")
  # test/asdasd3
  fwrite("test/asdasd4/package.cmake" "{}")

  fwrite("test/p4/hello.txt" "hello")

  fwrite("test/p5/package.cmake" "{\"content\":[\"**\", \"!hello2.txt\", \"--recurse\"]}" --json)
  fwrite("test/p5/hello.txt" "hello")
  fwrite("test/p5/hello2.txt" "hello")


  package_source_resolve_path("test/p4")
  ans(res)
  assert(res)


  package_source_resolve_path("test/asdasd")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "mypkg")

  ## path exists
  package_source_resolve_path("test/asdasd2")
  ans(res)
  assert(res)
  assertf({res.package_descriptor.id} STREQUAL "asdasd2")


  package_source_resolve_path("test/asdasd3")
  ans(res)
  assert(NOT res)

  package_source_resolve_path("test/asdasd4")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "asdasd4")
  assertf("{res.package_descriptor.version}" STREQUAL "0.0.0")


endfunction()
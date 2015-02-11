function(test)



  fwrite("test/asdasd/package.cmake" "{\"id\":\"mypkg\"}")
  mkdir("test/asdasd2")
  # test/asdasd3
  fwrite("test/asdasd4/package.cmake" "{}")

  fwrite("test/p4/hello.txt" "hello")

  fwrite("test/p5/package.cmake" "{\"content\":[\"**\", \"!hello2.txt\", \"--recurse\"]}" --json)
  fwrite("test/p5/hello.txt" "hello")
  fwrite("test/p5/hello2.txt" "hello")


  package_source_query_path("test/asdasd4" --package-handle)
  ans(res)
  assert(res)
  assertf({res.query_uri} STREQUAL "test/asdasd4")
  

  package_source_query_path("test/p5" --package-handle)
  ans(res)
  assert(res)
  assertf({res.query_uri} STREQUAL "test/p5")
  # this checksum_ functions change
  assertf({res.directory_descriptor.hash} MATCHES "[a-fA-F0-9]+")



  package_source_query_path("test/asdasd")
  ans(res)
  assert(res)
  assert("${res}" MATCHES "^file:///")

  ## path exists and is dir
  package_source_query_path("test/asdasd2")
  ans(res)
  assert(res)

  package_source_query_path("test/asdasd3")
  ans(res)
  assert(NOT res)

endfunction()
function(test)


  fwrite("test/asdasd/package.cmake" "{\"id\":\"mypkg\"}")
  mkdir("test/asdasd2")
  # test/asdasd3
  fwrite("test/asdasd4/package.cmake" "{}")

  fwrite("test/p4/hello.txt" "hello")

  fwrite("test/p5/package.cmake" "{\"content\":[\"**\", \"!hello2.txt\", \"--recurse\"]}" --json)
  fwrite("test/p5/hello.txt" "hello")
  fwrite("test/p5/hello2.txt" "hello")

  package_source_pull_path("test/p4" pull_dir_1)
  ans(res)
  assert(res)


  package_source_resolve_path("test/p4")
  ans(res)
  assert(res)

  package_source_query_path("test/asdasd4" --package-handle)
  ans(res)
  assert(res)
  json_print(${res})
  assertf({res.query_uri} STREQUAL "test/asdasd4")
  

  package_source_query_path("test/p5" --package-handle)
  ans(res)
  assert(res)
  assertf({res.query_uri} STREQUAL "test/p5")
  # this checksum_ functions change
  assertf({res.directory_descriptor.hash} STREQUAL "e796461f286636e4b12bb12ffafb605a")


  ## test wether content flag is respected and ignored files are not copied
  package_source_pull_path("test/p5" "tg2")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/tg2/hello.txt")
  assert(NOT EXISTS "${test_dir}/tg2/hello2.txt")


  package_source_pull_path("test/p4" "tg1")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/tg1/hello.txt")
  assertf({res.package_descriptor.id} STREQUAL "p4")

  package_source_pull_path("test/asdasd" --reference)
  ans(res)
  assert(res)
  assertf({res.content_dir} STREQUAL "${test_dir}/test/asdasd")

  package_source_pull_path("test/asdasd" p4)
  ans(res)
  assert(res)
  assertf({res.content_dir} STREQUAL "${test_dir}/p4")

  package_source_push_path("test/asdasd" "push/dir1")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/push/dir1/package.cmake")

  package_source_push_path("test/asdasd3" "push/dir2")
  ans(res)
  assert(NOT res)
  assert(NOT EXISTS "${test_dir}/push/dir2")

  package_source_push_path("test/asdasd4" "push/dir4")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/push/dir4")

  package_source_push_path("test/asdasd2" "push/dir2")
  ans(res)
  assert(NOT res)
  assert(NOT EXISTS "${test_dir}/push/dir2")


  package_source_pull_path("test/asdasd" "target/dir1")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/target/dir1/package.cmake")

  package_source_pull_path("test/asdasd4" "target/dir2")
  ans(res)
  assert(res)
  assert(IS_DIRECTORY "${test_dir}/target/dir2")

  package_source_pull_path("test/asdasd3" "target/dir3")
  ans(res)
  assert(NOT res)
  assert(NOT EXISTS "${test_dir}/target/dir3")


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
function(test)

  fwrite("test/asdasd/package.cmake" "{\"id\":\"mypkg\",\"include\":\"**\"}")
  mkdir("test/asdasd2")
  # test/asdasd3
  fwrite("test/asdasd4/package.cmake" "{}")



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

  package_source_resolve_path("test/asdasd2")
  ans(res)
  assert(NOT res)

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

  package_source_query_path("test/asdasd2")
  ans(res)
  assert(NOT res)

  package_source_query_path("test/asdasd3")
  ans(res)
  assert(NOT res)

endfunction()
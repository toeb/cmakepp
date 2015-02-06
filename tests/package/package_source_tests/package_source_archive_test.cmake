function(test)



  pushd(p1 --create)
    fwrite("README.md" "hello")
    fwrite("package.cmake" "{\"id\":\"pkg\", \"include\":\"**\"}")
  popd()

  pushd(tmpdir --create)
    fwrite(README.md "hello")
    compress("../archive1.tgz" "**")
  popd()

  pushd(tmpdir --create)
    fwrite(README.md "hello")
    compress("../archive2-3.2.1.tgz" "**")
  popd()
  
  pushd(tmpdir --create)
    fwrite(README.md "hello")
    fwrite(package.cmake "{\"id\":\"mymy\", \"version\":\"1.2.3\"}")
    compress("../archive3.tgz" "**")
  popd()

  checksum_file("archive3.tgz")
  ans(expected_checksum_3)


  package_source_resolve_archive("archive2-3.2.1.tgz")
  ans(res)
  assert(res) 




  package_source_query_archive("archive3.tgz" --package-handle)
  ans(package_handle)
  assertf({package_handle.query_uri} STREQUAL "archive3.tgz" )
  assertf({package_handle.archive_descriptor.hash} STREQUAL "${expected_checksum_3}")

  package_source_query_archive("archive3.tgz?hash=${expected_checksum_3}")
  ans(res)
  assert(res)

  package_source_query_archive("archive3.tgz?hash=1231adad")
  ans(res)
  assert(NOT res)



  package_source_push_archive(p1 "test.tgz")
  ans(res)
  assert(res)
  assert("${res}" MATCHES "^file:///.*test.tgz")
  assert(EXISTS "${test_dir}/test.tgz")
  uncompress_file("." "test.tgz" README.md)
  fread("README.md")
  ans(data)
  assert("${data}" STREQUAL "hello")




  package_source_pull_archive("lalala" "pull/p1")
  ans(res)
  assert(NOT res)
  assert(NOT EXISTS "${test_dir}/pull/p1")

  package_source_resolve_archive("${test_dir}/archive1.tgz")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "archive1")
  assertf("{res.package_descriptor.version}" STREQUAL "0.0.0")
  assertf("{res.uri}" MATCHES "^file:///")

  package_source_pull_archive("${test_dir}/archive1.tgz" "pull/p2")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull/p2/README.md")

  package_source_pull_archive("${test_dir}/archive2-3.2.1.tgz" "pull/p3")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull/p3/README.md")


  package_source_pull_archive("${test_dir}/archive3.tgz" "pull/p4")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull/p4/README.md")  
  assert(EXISTS "${test_dir}/pull/p4/package.cmake")  


  package_source_resolve_archive("lalala")
  ans(res)
  assert(NOT res)

  package_source_resolve_archive("${test_dir}")
  ans(res)
  assert(NOT res)


  package_source_resolve_archive("${test_dir}/archive2-3.2.1.tgz")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "archive2")
  assertf("{res.package_descriptor.version}" STREQUAL "3.2.1")
  assertf("{res.uri}" MATCHES "^file:///")

  package_source_resolve_archive("${test_dir}/archive3.tgz")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "mymy")
  assertf("{res.package_descriptor.version}" STREQUAL "1.2.3")
  assertf("{res.uri}" MATCHES "^file:///")


  package_source_query_archive("lalala")
  ans(res)
  assert(NOT res)

  package_source_query_archive("${test_dir}")
  ans(res)
  assert(NOT res)

  package_source_query_archive("${test_dir}/archive1.tgz")
  ans(res)
  assert(res)
  assert("${res}" MATCHES "^file:///")







endfunction()
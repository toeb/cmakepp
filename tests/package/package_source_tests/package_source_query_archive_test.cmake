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
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




  package_source_resolve_archive("${test_dir}/archive3.tgz")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "mymy")
  assertf("{res.package_descriptor.version}" STREQUAL "1.2.3")
  assertf("{res.uri}" MATCHES "^file:///")
  


  package_source_resolve_archive("archive2-3.2.1.tgz")
  ans(res)
  assert(res) 






  package_source_resolve_archive("${test_dir}/archive1.tgz")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "archive1")
  assertf("{res.package_descriptor.version}" STREQUAL "0.0.0")
  assertf("{res.uri}" MATCHES "^file:///")


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

  



endfunction()
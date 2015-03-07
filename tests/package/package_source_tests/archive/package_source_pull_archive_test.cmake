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



  package_source_pull_archive("${test_dir}/archive1.tgz" "pull/p2")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull/p2/README.md")

  package_source_pull_archive("${test_dir}/archive2-3.2.1.tgz" "pull/p3")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull/p3/README.md")



  package_source_pull_archive("lalala" "pull/p1")
  ans(res)
  assert(NOT res)
  assert(NOT EXISTS "${test_dir}/pull/p1")

  package_source_pull_archive("${test_dir}/archive3.tgz" "pull/p4")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull/p4/README.md")  
  assert(EXISTS "${test_dir}/pull/p4/package.cmake")  





endfunction()
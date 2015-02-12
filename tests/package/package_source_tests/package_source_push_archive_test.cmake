function(test)


  pushd(p1 --create)
    fwrite("README.md" "hello")
    fwrite("package.cmake" "{\"id\":\"pkg\", \"content\":\"**\"}")
  popd()


  path_package_source()
  ans(path_source)

  package_source_push_archive(${path_source} "p1" => "test.tgz")
  ans(res)
  assert(res)
  assertf("{res.uri}" MATCHES "^file:///.*test.tgz")
  assert(EXISTS "${test_dir}/test.tgz")
  uncompress_file("." "test.tgz" README.md)
  fread("README.md")
  ans(data)
  assert("${data}" STREQUAL "hello")


  ## check that when generating to a directory 
  ## the filename is correctly chosen
  package_source_push_archive(${path_source} "p1" => .)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pkg-0.0.0.tgz")



endfunction()
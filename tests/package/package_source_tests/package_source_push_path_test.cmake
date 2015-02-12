function(test)

  fwrite("test/asdasd/package.cmake" "{\"id\":\"mypkg\"}")
  mkdir("test/asdasd2")
  # test/asdasd3
  fwrite("test/asdasd4/package.cmake" "{}")

  fwrite("test/p4/hello.txt" "hello")

  fwrite("test/p5/package.cmake" "{\"content\":[\"**\", \"!hello2.txt\", \"--recurse\"]}" --json)
  fwrite("test/p5/hello.txt" "hello")
  fwrite("test/p5/hello2.txt" "hello")


  path_package_source()
  ans(path_source)


  package_source_push_path(${path_source} test/asdasd => "push/dir1")
  ans(package_handle)
  assert(package_handle)
  assert(EXISTS "${test_dir}/push/dir1/package.cmake")

  package_source_push_path(${path_source} test/bsdsdsds => "push/dir2")
  ans(package_handle)
  assert(NOT package_handle)


  pushd(push/dir3 --create)
    package_source_push_path(${path_source} ../../test/asdasd)
    ans(package_handle)
    assert(package_handle)
    assert(EXISTS "${test_dir}/push/dir3/package.cmake")
  popd()

  



endfunction()
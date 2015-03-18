function(test)


  fwrite("test/asdasd/package.cmake" "{\"id\":\"mypkg\"}")
  mkdir("test/asdasd2")
  # test/asdasd3
  fwrite("test/asdasd4/package.cmake" "{}")

  fwrite("test/p4/hello.txt" "hello")

  fwrite("test/p5/package.cmake" "{\"content\":[\"**\", \"!hello2.txt\", \"--recurse\"]}")
  fwrite("test/p5/hello.txt" "hello")
  fwrite("test/p5/hello2.txt" "hello")


  package_source_pull_path("test/p4" pull_dir_1)
  ans(res)
  assert(res)



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


endfunction()
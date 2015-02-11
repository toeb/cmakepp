function(test)

  fwrite("test/asdasd/package.cmake" "{\"id\":\"mypkg\"}")
  mkdir("test/asdasd2")
  # test/asdasd3
  fwrite("test/asdasd4/package.cmake" "{}")

  fwrite("test/p4/hello.txt" "hello")

  fwrite("test/p5/package.cmake" "{\"content\":[\"**\", \"!hello2.txt\", \"--recurse\"]}" --json)
  fwrite("test/p5/hello.txt" "hello")
  fwrite("test/p5/hello2.txt" "hello")

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


endfunction()
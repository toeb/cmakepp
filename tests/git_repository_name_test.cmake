function(test)
  git_repository_name("https://github.com/toeb/oo-cmake.git")
  ans(res)
  assert("${res}" STREQUAL "oo-cmake")

  git_repository_name("${test_dir}/dir1")
  ans(res)
  assert("${res}" STREQUAL "dir1")



endfunction()
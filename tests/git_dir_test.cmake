function(test)

  pushd(repo --create)
  git(init)
  pushd("a/b/c/d" --create)

  git_dir()
  ans(res)
  popd()
  popd()

  assert("${res}" STREQUAL "${test_dir}/repo/.git")


  cps_dir()
  ans(res)

  assert(NOT res)

endfunction()
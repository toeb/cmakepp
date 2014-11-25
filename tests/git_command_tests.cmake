function(test)

  git(--version)
  ans(res)
  assert("${res}" MATCHES "git")

  pushd("dir1" --create)  
  git(init --return-code)
  ans(ret)
  assert("${ret}" EQUAL 0)
  assert(EXISTS "${test_dir}/dir1/.git")

  ## create a repo and add a file to it
  fwrite(README.md "hello world")
  git(add . --return-code)
  ans(ret)
  assert("${ret}" EQUAL 0)
  git(commit -m "initial commit" --return-code)
  ans(ret)
  assert("${ret}" EQUAL 0)

  popd()

  ## clone local repo
  pushd(dir2 --create)
  git(clone ../dir1 . --return-code)
  ans(ret)
  assert("${ret}" EQUAL 0)
  assert(EXISTS "${test_dir}/dir2/README.md")
  popd()


  ## clone remote repo (of oocmake)
  pushd(dir3 --create)
  git(clone "https://github.com/toeb/oo-cmake" . --return-code)
  ans(ret)
  assert("${ret}" EQUAL 0)
  assert(EXISTS "${test_dir}/dir3/cmake/core/git/git.cmake")




endfunction()
function(test)






  pushd(localrepo --create)
    git(init)
    fwrite("README.md" "hello")
    git(add .)
    git(commit -m "hellothere")
    git(checkout -b devel_branch)
    fwrite("README2.md" "hello")
    git(add .)
    git(commit -m "update")
    git(checkout master)
  popd()


  package_source_pull_git("https://github.com/toeb/cmakepp.git?rev=b087891bd8011b2b87689e84b578561dd2e151ad" "pull_dir_1")
  ans(res)
  assert(EXISTS "${test_dir}/pull_dir_1")
  assert(EXISTS "${test_dir}/pull_dir_1/package.cmake")
  assert(res)
  
  # does not work with ssh/https mixture of submodule
  #package_source_pull_git("ssh://git@github.com/toeb/cutil" "clone5")
  #ans(res)
  #assert(res)
  #assert(EXISTS "${test_dir}/clone5/README.md")



  package_source_pull_git("https://github.com/toeb/cmakepp" "clone3")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.license}" STREQUAL "MIT")
  assert(EXISTS "${test_dir}/clone3/README.md")


  package_source_pull_git("localrepo" "localclone1")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/localclone1/README.md")
  assert(NOT EXISTS "${test_dir}/localclone1/README2.md")

  package_source_pull_git("localrepo?branch=devel_branch" "localclone2")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/localclone2/README.md")
  assert(EXISTS "${test_dir}/localclone2/README2.md")



endfunction()
function(test)


  ## pull hg repo
  package_source_pull_bitbucket(toeb/test_repo_hg "pull/test_hg1")
  ans(res)
  assert(res)
  assert(IS_DIRECTORY "${test_dir}/pull/test_hg1")
  assertf("{res.package_descriptor.id}" STREQUAL "toeb/test_repo_hg")
  assertf("{res.package_descriptor.custom_property}" STREQUAL "custom_value")


  package_source_pull_bitbucket(toeb/test_repo_git "pull/test_git1")
  ans(res)
  assert(res)
  assert(IS_DIRECTORY "${test_dir}/pull/test_hg1")
  assertf("{res.package_descriptor.id}" STREQUAL "toeb/test_repo_git")
  assertf("{res.package_descriptor.custom_property}" STREQUAL "custom_value")

  


  ## pull git https
  # package_source_pull_bitbucket("tutorials/markdowndemo" "pull/dir1")
  # ans(res)
  # assert(res)
  # assert(IS_DIRECTORY "${test_dir}/pull/dir1/.git")
  # assert(EXISTS "${test_dir}/pull/dir1/README.md")

  ## pull git ssh incoclusive because missing certificates
  # package_source_pull_bitbucket("tutorials/markdowndemo" "pull/dir2" --use-ssh)
  # ans(res)
  # assert(res)
  # assert(IS_DIRECTORY "${test_dir}/pull/dir2/.git")
  # assert(EXISTS "${test_dir}/pull/dir2/README.md")

endfunction()
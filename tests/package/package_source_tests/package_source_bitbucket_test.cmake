function(test)




  set(bitbucket_devel_token "")


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

  


  package_source_resolve_bitbucket("tutorials/tutorials.bitbucket.org")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "tutorials/tutorials.bitbucket.org")
  assertf("{res.package_descriptor.description}" STREQUAL "Site for tutorial101 files")
  assertf("{res.package_descriptor.version}" STREQUAL "0.0.0")
  assertf("{res.uri}" STREQUAL "bitbucket:tutorials/tutorials.bitbucket.org")


  package_source_resolve_bitbucket("")
  ans(res)
  assert(NOT res)

  package_source_resolve_bitbucket("tutorials")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("tutorials/asdasdasd")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("tutorials")
  ans(res)
  assert(${res} CONTAINS "bitbucket:tutorials/tutorials.bitbucket.org")
  list(LENGTH res len)
  assert(${len} GREATER 1)

  package_source_query_bitbucket("tutorials/tutorials.bitbucket.org")
  ans(res)
  assert("${res}" STREQUAL "bitbucket:tutorials/tutorials.bitbucket.org")



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
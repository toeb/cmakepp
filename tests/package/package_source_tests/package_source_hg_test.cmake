function(test)
  find_package(Hg)
  if(NOT HG_FOUND)
    message("test inconclusive - mercurial not found")
    return()
  endif()

  package_source_pull_hg("https://bitbucket.org/toeb/test_repo_hg" pull_dir_1)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull_dir_1/package.cmake")


  package_source_resolve_hg("https://bitbucket.org/toeb/test_repo_hg")
  ans(res)

  assert(res)
  assertf({res.package_descriptor.id} STREQUAL "test_repo_hg")# from filename
  assertf({res.package_descriptor.custom_property} STREQUAL "custom_value")# from package_descriptor


  package_source_query_hg("https://bitbucket.org/toeb/test_repo_hg" --package-handle)
  ans(res)

  assert(res)
  assertf({res.scm_descriptor.scm} STREQUAL "hg")
  assertf({res.scm_descriptor.ref.name} STREQUAL "tip")
  assertf({res.scm_descriptor.ref.type} STREQUAL "tag")


  package_source_query_hg("https://bitbucket.org/toeb/test_repo_hg?rev=61a518679ab8" --package-handle)
  ans(res)
  
  assert(res)
  assertf({res.scm_descriptor.scm} STREQUAL "hg")
  assertf({res.scm_descriptor.ref.name} STREQUAL "61a518679ab8")
  assertf({res.scm_descriptor.ref.type} STREQUAL "rev")
  assertf({res.scm_descriptor.ref.hash} STREQUAL "61a518679ab8")
  assertf({res.scm_descriptor.ref.uri} STREQUAL "https://bitbucket.org/toeb/test_repo_hg")



  package_source_pull_hg("https://bitbucket.org/tutorials/hgsplitpractice" "clone1")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/clone1/bigdir")


  # does not work because ssh is missing on my machine
  #package_source_query_hg("ssh://hg@bitbucket.org/tutorials/tutorials.bitbucket.org")
  #ans(res)

  package_source_query_hg("https://bitbucket.org/toeb/test_repo_hg")
  ans(res)
  assert(res)


  package_source_query_hg("https://bitbucket.org/tutorials/tutorials.bitbucket.orgasdasdasd")
  ans(res)
  assert(NOT res)


endfunction()
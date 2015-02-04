function(test)
  find_package(Hg)
  if(NOT HG_FOUND)
    message("test inconclusive - mercurial not found")
    return()
  endif()


  package_source_pull_hg("https://bitbucket.org/tutorials/hgsplitpractice" "clone1")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/clone1/bigdir")


  # does not work because ssh is missing on my machine
  #package_source_query_hg("ssh://hg@bitbucket.org/tutorials/tutorials.bitbucket.org")
  #ans(res)

  package_source_query_hg("https://bitbucket.org/tutorials/tutorials.bitbucket.org")
  ans(res)
  assert(res)

  package_source_query_hg("https://bitbucket.org/tutorials/tutorials.bitbucket.orgasdasdasd")
  ans(res)
  assert(NOT res)


endfunction()
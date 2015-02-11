function(test)
  
  package_source_pull_hg("https://bitbucket.org/toeb/test_repo_hg" pull_dir_1)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull_dir_1/package.cmake")


 
  package_source_pull_hg("https://bitbucket.org/tutorials/hgsplitpractice" "clone1")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/clone1/bigdir")



endfunction()
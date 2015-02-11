function(test)




  package_source_pull_svn("https://github.com/toeb/test_repo?rev=1" p1)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/p1")
  assert(EXISTS "${test_dir}/p1/README.md")
  assert(EXISTS "${test_dir}/p1/.svn")
  
  

endfunction()
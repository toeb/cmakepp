function(test)

  # pull tests
  package_source_pull_github("toeb/cmakepp" test)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/test/README.md")
  
  # query tests
  package_source_query_github("toeb")
  ans(res)
  assert(${res} CONTAINS "github:toeb/cmakepp")
  assert(${res} CONTAINS "github:toeb/cutil")




endfunction()
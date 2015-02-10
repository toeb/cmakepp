function(test)

  # pull tests
  package_source_pull_github("toeb/cmakepp" test)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/test/README.md")
  


endfunction()
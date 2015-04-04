function(test)






  package_source_pull_host("")
  ans(res)
  assert(NOT res)


  package_source_pull_host("host:localhost" "install_dir")
  ans(res)
  assert(res)
  assert(EXISTS "install_dir")




endfunction()
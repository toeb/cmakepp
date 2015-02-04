function(test)




  package_source_query_svn("svnscm+https://github.com/toeb/test_repo@1")
  ans(res)
  assert("${res}" STREQUAL "svnscm+https://github.com/toeb/test_repo?rev=1")

  
  package_source_query_svn("https://github.com/toeb/test_repo")
  ans(res)
  assert(res)
  assert("${res}" STREQUAL "svnscm+https://github.com/toeb/test_repo")

  package_source_query_svn("https://github.com/toeb/asdasdasdasd")
  ans(res)
  assert(NOT res)

  package_source_resolve_svn("https://github.com/toeb/test_repo?rev=1")
  ans(res)
  assert(res)

  package_source_pull_svn("https://github.com/toeb/test_repo?rev=1" p1)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/p1")
  assert(EXISTS "${test_dir}/p1/README.md")
  assert(EXISTS "${test_dir}/p1/.svn")
  
  
  package_source_query_svn("svnscm+https://github.com/toeb/test_repo")
  ans(res)
  assert("${res}" STREQUAL "svnscm+https://github.com/toeb/test_repo")
  
  package_source_query_svn("https://github.com/toeb/test_repo")
  ans(res)
  assert(res)
  assert("${res}" STREQUAL "svnscm+https://github.com/toeb/test_repo")

  package_source_query_svn("https://github.com/toeb/asdasdasdasd")
  ans(res)
  assert(NOT res)

endfunction()
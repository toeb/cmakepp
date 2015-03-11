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
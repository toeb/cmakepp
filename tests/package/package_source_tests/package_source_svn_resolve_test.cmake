function(test)

  package_source_resolve_svn("https://github.com/toeb/test_repo?rev=1")
  ans(res)
  assert(res)

endfunction()
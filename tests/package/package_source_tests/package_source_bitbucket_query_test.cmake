function(test)
  ## <user> -> <user>/*
  ## <user>/* -> bitbucket:<user>/<repo>...
  ## <user>/<repo> -> bitbucket:<user>/<repo>/"branches"/<default branch>?hash=<commit>
  ## <user>/<repo>.*?hash=<commit> -> bitbucket:<user>/<repo>?hash=<commit>
  ## <user>/<repo>/* -> bitbucket:<user>/<repo>/"branches"|"tags"/<ref name>?hash=<commit>
  ## <user>/<repo>/branches ->
  ## <user>/<repo>/tags ->
  ## <user>/<repo>/<name> -> <user>/<repo>/*/<name>
  ## <user>/<repo>/*/<name> -> bitbucket:<user>/<repo>/"branches"|"tags"/<name>?hash=<commit>
  package_source_query_bitbucket("eigen/eigen/3.0.0" --package-handle)
  ans(res)
  assert(res)
  assertf({res.bitbucket_descriptor.remote_ref.ref} STREQUAL "3.0.0")



  package_source_query_bitbucket("toeb/test_repo_hg" --package-handle)
  ans(res)
  assertf({res.uri} MATCHES "bitbucket:toeb\\/test_repo_hg\\/branches\\/default\\?hash")
  assertf({res.query_uri} MATCHES "toeb/test_repo_hg")
  assertf({res.bitbucket_descriptor.remote_ref.ref} MATCHES "default")
  assertf({res.bitbucket_descriptor.remote_ref.ref_type} MATCHES "branches")

  package_source_query_bitbucket("toeb")
  ans(res)
  assert(${res} CONTAINS "bitbucket:toeb/test_repo_hg")
  assert(${res} CONTAINS "bitbucket:toeb/test_repo_git")

  package_source_query_bitbucket("toeb/*")
  ans(res)
  assert(${res} CONTAINS "bitbucket:toeb/test_repo_hg")
  assert(${res} CONTAINS "bitbucket:toeb/test_repo_git")

  package_source_query_bitbucket("toeb/test_repo_git")
  ans(res)
  assert("${res}" MATCHES "bitbucket:toeb\\/test_repo_git\\/branches\\/master\\?hash=[0-9a-fA-F]+")

  package_source_query_bitbucket("eigen/eigen/*")
  ans(res)
  assert("${res}" MATCH "3\\.1\\.0")
  

  package_source_query_bitbucket("")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("http:")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("bitbucket:")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("bitbucket:toeb")
  ans(res)

  package_source_query_bitbucket("bitbucket:toeb/*")
  ans(res)


  package_source_query_bitbucket("bitbucket:toeb/test_repo_hg")
  ans(res)

  package_source_query_bitbucket("bitbucket:toeb/test_repo_hg/master")
  ans(res)

  package_source_query_bitbucket("bitbucket:toeb/test_repo_hg/branches/master")
  ans(res)


  package_source_query_bitbucket("bitbucket:toeb/test_repo_hg/branches")
  ans(res)


  package_source_query_bitbucket("bitbucket:toeb/test_repo_hg/tags")
  ans(res)



  package_source_query_bitbucket("bitbucket:toeb/test_repo_hg/commits?hash=123123123123")
  ans(res)
  assert(res)

  package_source_query_bitbucket("")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("tutorials/asdasdasd")
  ans(res)
  assert(NOT res)


endfunction()
function(test)

  package_source_query_bitbucket("")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("tutorials/asdasdasd")
  ans(res)
  assert(NOT res)

  package_source_query_bitbucket("tutorials")
  ans(res)
  assert(${res} CONTAINS "bitbucket:tutorials/tutorials.bitbucket.org")
  list(LENGTH res len)
  assert(${len} GREATER 1)

  package_source_query_bitbucket("tutorials/tutorials.bitbucket.org")
  ans(res)
  assert("${res}" STREQUAL "bitbucket:tutorials/tutorials.bitbucket.org")


endfunction()
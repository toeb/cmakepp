function(test)



  package_source_query_host("" --package-handle)
  ans(res)

  assert(NOT res)

  package_source_query_host("host:" --package-handle)
  ans(res)
  assert(res)
  assertf("{res.uri}" STREQUAL "host:localhost")
  assertf("{res.query_uri}" STREQUAL "host:")
  assertf("{res.environment_descriptor}" STREQUAL ISNOTNULL)


  package_source_query_host("host:localhost" --package-handle)
  ans(res)
  assert(res)


  package_source_query_host("host:asd" --package-handle)
  ans(res)
  assert(NOT res)

  package_source_query_host("host:")
  ans(res)
  assert("${res}" STREQUAL "host:localhost")



endfunction()
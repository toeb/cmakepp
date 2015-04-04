function(test)


  package_source_resolve_host("")
  ans(res)
  assert(NOT res)

  package_source_resolve_host("host:localhost")
  ans(res)
  assert(res)

  assertf({res.package_descriptor} ISNOTNULL)
  assertf({res.package_descriptor.environment_descriptor} ISNOTNULL)


endfunction()
function(test)
  package_source_resolve_bitbucket("eigen/eigen/tags/3.0.1")
  ans(res)
  assertf("{res.package_descriptor.version}" STREQUAL "3.0.1")


   package_source_resolve_bitbucket("toeb")
  ans(res)
  assert(NOT res)
  log_last_error_print()


  package_source_resolve_bitbucket("toeb/test_repo_hg")
  ans(res)
  assert(res)
  assertf({res.package_descriptor.custom_property} STREQUAL "custom_value")




  package_source_resolve_bitbucket("tutorials/tutorials.bitbucket.org")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "tutorials/tutorials.bitbucket.org")
  assertf("{res.package_descriptor.description}" STREQUAL "Site for tutorial101 files")


  package_source_resolve_bitbucket("")
  ans(res)
  assert(NOT res)

  package_source_resolve_bitbucket("tutorials")
  ans(res)
  assert(NOT res)

endfunction()
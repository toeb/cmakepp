function(test)

 package_source_resolve_hg("https://bitbucket.org/toeb/test_repo_hg")
  ans(res)

  assert(res)
  assertf({res.package_descriptor.id} STREQUAL "test_repo_hg")# from filename
  assertf({res.package_descriptor.custom_property} STREQUAL "custom_value")# from package_descriptor




endfunction()
function(test)

  # pull tests
  package_source_pull_github("toeb/cmakepp" test)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/test/README.md")
  
  # query tests
  package_source_query_github("toeb")
  ans(res)
  assert(${res} CONTAINS "github:toeb/cmakepp")
  assert(${res} CONTAINS "github:toeb/cutil")


  package_source_query_github("toeb/cmakepp")
  ans(res)
  assert("${res}" STREQUAL "github:toeb/cmakepp")

  package_source_query_github("toeb/cmakepp2asdasdas")
  ans(res)
  assert(NOT res)
  
  package_source_query_github("github:toeb/cmakepp")
  ans(res)
  assert("${res}" STREQUAL "github:toeb/cmakepp")
  
  package_source_query_github("")
  ans(res)
  assert(NOT res)

  # resolve tests
  package_source_resolve_github("toeb/cmakepp")
  ans(res)
  assertf({res.package_descriptor.id} STREQUAL "oo-cmake")

  package_source_resolve_github("toeb/cppdynamic")
  ans(res)
  assertf({res.package_descriptor.id} STREQUAL "cppdynamic")
  assertf({res.package_descriptor.description} STREQUAL "a dynamic object implementation in c++")

  package_source_resolve_github("toeb/asdasdas")
  ans(res)
  assert(NOT res)

  package_source_resolve_github("")
  ans(res)
  assert(NOT res)

  package_source_resolve_github("toeb")
  ans(res)
  assert(NOT res)



endfunction()
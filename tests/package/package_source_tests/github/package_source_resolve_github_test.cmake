function(test)

  # resolve tests
  package_source_resolve_github("toeb/cmakepp")
  ans(res)
  assert(res)
  assertf({res.package_descriptor.id} STREQUAL "cmakepp")

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
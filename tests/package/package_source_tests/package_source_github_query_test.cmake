function(test)



  package_source_query_github("toeb/cmakepp" --package-handle)
  ans(res)

  assert(res)
  assertf({res.uri} STREQUAL "github:toeb/cmakepp")
  assertf({res.query_uri} STREQUAL "toeb/cmakepp")



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


endfunction()
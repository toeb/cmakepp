function(test)


  package_source_query_github("toeb/cmakepp")
  ans(res)
  assert(res)
  assert(${res} MATCHES "^github:toeb/cmakepp/branches/master\\?hash=[0-9a-fA-F]+$")
  ## non existant repo
  package_source_query_github("toeb/adsasdasd")
  ans(res)
  assert(NOT res)

  package_source_query_github("")
  ans(res)
  assert(NOT res)

  package_source_query_github("toeb")
  ans(res)
  assert(res)
  assert(${res} CONTAINS "github:toeb/cmakepp")
  
  package_source_query_github("toeb/*")
  ans(res)
  assert(res)
  assert(${res} CONTAINS "github:toeb/cmakepp")

  package_source_query_github("toeb/cmakepp/*")
  ans(res)
  assert(${res} MATCH toeb/cmakepp/branches/master) ## todo string contains or similar


  package_source_query_github("toeb/cmakepp/master")
  ans(res)
  assert(${res} MATCHES "^github:toeb/cmakepp/branches/master\\?hash=[0-9a-fA-F]")

  package_source_query_github("toeb/cmakepp/branches/*")
  ans(res)
  assert("${res}" MATCH "toeb/cmakepp/branches/master")
  assert(NOT "${res}" MATCH "toeb/cmakepp/tags")
  #assert("${")

  package_source_query_github("toeb/cmakepp/tags/*")
  ans(res)
  assert(NOT "${res}" MATCH "toeb/cmakepp/branches")
  assert("${res}" MATCH "toeb/cmakepp/tags")



endfunction()
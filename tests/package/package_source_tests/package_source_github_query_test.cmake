function(test)
  set(github_api_token "?client_id=$ENV{GITHUB_DEVEL_TOKEN_ID}&client_secret=$ENV{GITHUB_DEVEL_TOKEN_SECRET}")

  #https://api.github.com/repos/toeb/cmakepp/branches
  #https://api.github.com/repos/toeb/cmakepp/tags
  #https://api.github.com/repos/toeb/cmakepp/commits
  #http_get("https://api.github.com/repos/toeb/cmakepp/commits/8ae06c58b628f4959802afdd56aa9a5b52189836${github_api_token}")
  #ans(res)
  #message("${res}")
  
  # http_get("https://api.github.com/repos/toeb/cmakepp${github_api_token}")
  # ans(res)
  # message("${res}")
  
  # http_get("https://api.github.com/repos/toeb/cmakepp/tags${github_api_token}")
  # ans(res)
  # message("${res}")

  # http_get("https://api.github.com/repos/toeb/cmakepp/branches${github_api_token}")
  # ans(res)
  # message("${res}")
  # http_get("https://api.github.com/repos/toeb/cmakepp/branches${github_api_token}")

  package_source_query_github("github:toeb")
  ans(res)
  
json_print(${res})
  return()
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
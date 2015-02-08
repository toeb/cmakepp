function(test)


  ## fail test
  # http_get("http://notahost.tld")
  # ans(res)
  # assert(NOT res)


  set(github_api_token "?client_id=$ENV{GITHUB_DEVEL_TOKEN_ID}&client_secret=$ENV{GITHUB_DEVEL_TOKEN_SECRET}")
  http_get("https://api.github.com/repos/toeb/cmakepp${github_api_token}")
  ans(content)
  assert(content)

  http_get("https://api.github.com/repos/toeb/cmakepp${github_api_token}" --json)
  ans(content)
  assert(content)
  assertf("{content.full_name}" STREQUAL "toeb/cmakepp")

  http_get("http://notahost.tld" --silent-fail)
  ans(res)
  assert(NOT res)



  http_get("http://notahost.tld" --response)
  ans(res)

  assert(res)
  assertf(NOT "{res.client_status}" EQUAL "0")
  assertf("{res.content}_" STREQUAL "_")
  assertf("{res.request_url}" STREQUAL "http://notahost.tld")


  http_get("http://notahost.tld" --return-code)
  ans(error)
  assert( error)


  http_get("http://google.de" --response)
  ans(res)

  assert(res)
  assertf("{res.client_status}" EQUAL 0)
  assertf("{res.request_url}" STREQUAL "http://google.de")
  assertf("{res.http_status_code}" STREQUAL "200")
  assertf("{res.http_reason_phrase}" STREQUAL "OK")
  assertf(NOT "{res.http_headers.Date}_" STREQUAL "_")

  http_get("http://google.de" --return-code)
  ans(error)
  assert(NOT error)


  http_get("http://google.de")
  ans(content)
  assert(content)


  http_get("http://google.de")
  ans(content)
  assert(content)



endfunction()

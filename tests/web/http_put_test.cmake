function(http_put_test)
  http_put("http://httpbin.org/put" "{id:'hello world'}" --json)
  ans(res)
  assertf("{res.json.id}" STREQUAL "hello world")

  http_put("http://httpbin.org/put" "{id:'hello world'}" --return-code --show-progress)
  ans(error)
  assert(NOT error)

  http_put("http://httpbin.org/put" "{id:'hello world'}" --return-code)
  ans(error)
  assert("${error}" EQUAL "0")

  http_put("http://httpbin.org/put" "{id:'hello world'}")
  ans(res)
  assert("${res}" MATCHES "hello world")



endfunction()
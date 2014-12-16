function(test)

  string_match("abc" b)
  ans(res)
  assert(res)

  string_match("abc" d)
  ans(res)
  assert(NOT res)

  string_match("" a)
  ans(res)
  assert(NOT res)

  string_match("" "")
  ans(res)
  assert(res)


  string_match("asdasd" "")
  ans(res)
  assert(res)
endfunction()
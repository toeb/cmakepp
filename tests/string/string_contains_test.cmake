function(test)

  
  string_contains("abc" "a")
  ans(res)
  assert(res)


  string_contains("abc" "d")
  ans(res)
  assert(NOT res)


  string_contains("" "a")
  ans(res)
  assert(NOT res)

  string_contains("abcd" "bc")
  ans(res)
  assert(res) 


  string_contains("" "")
  ans(res)
  assert(res)


  string_contains("abcd" "")
  ans(res)
  assert(res)


endfunction()
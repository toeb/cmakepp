function(test)

  string_normalize_index("abc" 0)
  ans(res)
  assert("${res}" EQUAL "0")

  string_normalize_index("abc" 1)
  ans(res)
  assert("${res}" EQUAL "1")


  string_normalize_index("abc" 2)
  ans(res)
  assert("${res}" EQUAL "2")

  string_normalize_index("abc" 3)
  ans(res)
  assert("${res}" EQUAL 3)


  string_normalize_index("abc" "-1")
  ans(res)
  assert("${res}" EQUAL 3)

  string_normalize_index("" 0)
  ans(res)
  assert("${res}" EQUAL "0")


  string_normalize_index("abc" -2)
  ans(res)
  assert("${res}" EQUAL "2")


  string_normalize_index("abc" -3)
  ans(res)
  assert("${res}" EQUAL "1")


  string_normalize_index("abc" -4)
  ans(res)
  assert("${res}" EQUAL "0")

endfunction()
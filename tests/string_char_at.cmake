function(test)
  
  set(str "abcdefg")

  string_char_at( 0 "${str}")
  ans(res)
  assert("${res}" STREQUAL "a")
  
  string_char_at( 1 "${str}")
  ans(res)
  assert("${res}" STREQUAL "b")


  string_char_at( -2 "${str}")
  ans(res)
  assert("${res}" STREQUAL "g")


  string_char_at( -3 "${str}")
  ans(res)
  assert("${res}" STREQUAL "f")

  

endfunction()
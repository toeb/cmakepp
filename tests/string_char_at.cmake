function(test)
  
  set(str "abcdefg")

  string_char_at(res 0 "${str}")
  assert("${res}" STREQUAL "a")
  
  string_char_at(res 1 "${str}")
  assert("${res}" STREQUAL "b")


  string_char_at(res -2 "${str}")
  assert("${res}" STREQUAL "g")


  string_char_at(res -3 "${str}")
  assert("${res}" STREQUAL "f")

  

endfunction()
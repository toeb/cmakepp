function(test)
  
  string(ASCII 31 separator)

  set(uut ";")
  string_semicolon_encode("${uut}")
  ans(res)
  assert("${res}" STREQUAL "${separator}")
  

  string_semicolon_decode("${separator}")
  ans(res)
  assert("_${res}_" EQUALS "_;_")

  

endfunction()
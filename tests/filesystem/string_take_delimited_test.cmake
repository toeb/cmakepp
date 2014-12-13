function(test)

  set(str "'c:\\a b c\\d e f'")
  string_take_delimited(str ')
  ans(res)
  assert("${res}" STREQUAL "c:\\a b c\\d e f")



  set(str "<asdas>")
  string_take_delimited(str "<>")
  ans(res)
  assert("${res}" STREQUAL "asdas")
  
  #return()

#todo
  set(str "\"c:\\a b c\\d e\" f\"")
  string_take_delimited(str "\"")
  ans(res)
  assert("${res}" STREQUAL "c:\\a b c\\d e\" f")


endfunction()
function(test)



  set(str "'c:\\a b c\\d e \\'f'")

 string_take_delimited(str ')
 ans(res)
 assert("${res}" STREQUAL "c:\\a b c\\d e 'f")


  set(str "'a','b'")
  string_take_delimited(str "''")
  ans(res)

  assert("${res}" STREQUAL "a")

  

  set(str "'c:\\a b c\\d e f'")
  string_take_delimited(str ')
  ans(res)
  assert("${res}" STREQUAL "c:\\a b c\\d e f")



  set(str "<asdas>")
  string_take_delimited(str "<>")
  ans(res)
  assert("${res}" STREQUAL "asdas")
  

  set(str "\"wininit.exe\",\"480\",\"Services\",\"0\",\"616 K\",\"Unknown\",\"N/A\",\"0:00:00\",\"N/A\"")
  string_take_delimited(str)  
  ans(res)

  assert("${res}" STREQUAL "wininit.exe")



endfunction()
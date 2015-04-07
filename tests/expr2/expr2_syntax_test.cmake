function(test)
  set(exception "{'__$type__':'exception'}")
  ##### runtime tests #####


return()


  ## intepret statements
  define_test_function2(test_uut eval_expr2 interpret_statements "")

  eval_expr2(interpret_statements "" "a;b")
  ans(res)
  assert("${res}" STREQUAL b)


  eval_expr2(interpret_statements "" "a;b;c")
  ans(res)
  assert("${res}" STREQUAL c)

  test_uut("${exception}")
  test_uut("" "")
  test_uut("a" "a")





  ## interpret assign

  define_test_function2(test_uut eval_expr2 interpret_assign "")
function(alal)
  map_new()
  ans(asd)
  map_set(${asd} lol 123)
  return(${asd})
endfunction()
  obj("{b:{c:2}}")
  ans(a)
  eval_expr2(interpret_assign "--print-code" "$a.b.c = alal().lol")
  ans(res)
  assert("${res}" STREQUAL 123)
  assertf("{a.b.c}" STREQUAL 123)

return()
  set(a)
  eval_expr2(interpret_assign "" "$a = 1")
  ans(res)
  assert("${res}" EQUAL 1)
  assert("${a}" EQUAL 1)






  return()







endfunction()
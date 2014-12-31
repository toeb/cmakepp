function(test)



  define_test_function(test_uut set_at)


  set(thevar)
  test_uut("3" thevar 3)


  set(thevar)
  test_uut("asd" thevar asd)


  set(thevar 3)
  test_uut("[3,4]" thevar [] 4)


  set(thevar 3 4)
  test_uut("5" thevar 5)


  set(thevar)
  test_uut("{a:1}" thevar a 1)


  set(thevar 1 2)
  test_uut("{a:2}" thevar a 2)


  set(thevar 1 2 3)
  test_uut("[1,4,3]" thevar [1] 4)


  obj("{a:2}")
  ans(thevar)
  test_uut("{a:[2,3]}" thevar a [] 3)


  obj("{a:[2,3,4]}")
  ans(thevar)
  test_uut("{a:[2,5,4]}" thevar a [1] 5)
endfunction()
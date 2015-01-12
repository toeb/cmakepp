function(test)
  function(test_nav_set input expression new_value)
    data("${input}")
    ans(input)
    data("${new_value}")
    ans(new_value)
    nav_set("${input}" "${expression}" "${new_value}" )
    return_ans()
  endfunction()




  define_test_function(test_uut test_nav_set input expression new_value)

  test_uut(hello "" "" hello)
  test_uut(hello "123" "" hello)
  test_uut("hello;123;goodbye" "hello;you;goodbye" "[1]" 123)
  test_uut(123 "" "[]" 123 )
  test_uut("234;123" "234" "[]" 123)


  test_uut("{a:123}" "{a:234}" "a" "123")
  test_uut("{a:123}" "{}" "a" "123")
  test_uut("{a:[234,123]}" "{a:234}" "a[]" 123)


endfunction()
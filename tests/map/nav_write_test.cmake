function(test)



  function(test_nav_write input expression)
    data(${ARGN})
    ans(data)
    data("${input}")
    ans(input)
    nav_write("${input}" "${expression}" ${data})
    return_ans()
  endfunction()

  define_test_function(test_uut test_nav_write input expression)

#  test_uut("{a:[1,2,{c:3}]}" "{a:[1,2]}" "a[].c" 3) # toodo


  test_uut("{a:[2,3]}" "{a:2}" "a[]" 3)
  test_uut("{a:{b:123}}" "" "a.b" 123)
  test_uut("" "" "")
  test_uut("123" "" "" 123)
  test_uut("123" "" "[]"  123)
  test_uut("{a:123}" "" "a" 123)
  test_uut("{a:123}" "{}" a 123)
  test_uut("{a:123,b:123}" "{b:123}" a 123)
  test_uut("{a:{b:{c:123}}}" "" "a.b.c" 123)
  test_uut("{a:123}" "" "[].a" 123)
  test_uut("[{},{a:123}]" "{}" "[].a" 123) 
  test_uut("{a:{b:123}}" "{}" "a.b" 123)
  test_uut("{a:{b:123,c:123}}" "{a:{b:123}}" "a.c" 123)
  test_uut("{a:{b:123},c:123}" "{a:{b:123}}" "c" 123)

endfunction()
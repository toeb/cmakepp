function(test)


  define_test_function(test_uut nav_create_path expression)

  test_uut(123 "" 123)
  test_uut(123 "[]" 123)
  test_uut(123 "[][]" 123)
  test_uut("{a:123}" "a" 123)
  test_uut("{a:123}" "a[]" 123)
  test_uut("{a:{b:123}}" "a[].b" 123)
  test_uut("{a:{b:123}}" "a[].b[]" 123)



endfunction()
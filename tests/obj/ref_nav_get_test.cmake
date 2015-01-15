function(test)

  function(test_ref_nav_get  current_value expression)
   # message("expression: ${expression}")
    data("${current_value}")
    ans(current_value)
    ref_nav_get("${current_value}" "${expression}")
    ans(res)
    #json_print(${res})
    #message(" \n")
    return_ref(res)
  endfunction()

  define_test_function(test_uut test_ref_nav_get current_value expression)
  
  test_uut("{ref:null,property:null,value:null,range:null}" "" "&")
  test_uut("{ref:null,property:null,value:123,range:null}" "123" "&")
  test_uut("{ref:null,property:null,value:123,range:'<0>'}" "123" "&[0]")
  test_uut("{ref:{a:123},property:'a',value:123,range:null}" "{a:123}" "&a")
  test_uut("{ref:{a:[123,234,345]},property:'a',value:234,range:'<1>'}" "{a:[123,234,345]}" "&a[1]")



endfunction()
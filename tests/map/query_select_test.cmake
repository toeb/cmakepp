function(test)


  function(test_query query )
    data("${ARGN}")
    ans(data)
    timer_start(query_timer)
    query_select("${query}" ${data})
    ans(res)
    timer_print_elapsed(query_timer)
    return_ref(res)

  endfunction()

  define_test_function(test_uut test_query query)


  test_uut("a;b;c" "{' ':'true'}" "a;b;c")
  test_uut("{a:['a','b','c']}" "{'a[:]':'true'}" "{a:['a','b','c']}")


endfunction()
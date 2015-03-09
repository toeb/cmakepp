function(test)

  function(test_query_where query )
    data("${ARGN}")
    ans(data)
    data("${query}")
    ans(query)
    timer_start(query_timer)
    query_where("${query}" ${data})
    ans(res)
    timer_print_elapsed(query_timer)
    return_ref(res)
  endfunction()

  define_test_function(test_uut test_query_where query)


  test_uut("a;b;c" "{' ':'true'}" "a;b;c")
  test_uut("{a:['a','b','c']}" "{'a[:]':'true'}" "{a:['a','b','c']}")


endfunction()
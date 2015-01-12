function(test)


  function(test_nav_get input)
    data("${input}")
    ans(input)
    nav_tryget("${input}" ${ARGN})
    return_ans()
  endfunction()

  define_test_function(test_uut test_nav_get input)

  test_uut("egal" "egal")
  test_uut("egal" "egal" [0])
  test_uut("" "egal" a.b.c)

  test_uut(123 "{a:{b:{c:123}}}" a.b.c)
  test_uut("{c:123}" "{a:{b:{c:123}}}" a.b)
  test_uut("" "{a:{b:{c:123}}}" a.b.c.d)


  return()  # todo
  data("{a:{b:{c:123}}}")
  ans(data)
  timer_start(timer)

  foreach(i RANGE 0 100)
    nav_tryget("${data}" "a.b.c")
    ans(res)
  endforeach()

  timer_print_elapsed(timer)

  timer_start(timer1)

  foreach(i RANGE 0 100)
    map_navigate("${data}" "a.b.c")
    ans(res)
  endforeach()

  timer_print_elapsed(timer1)


  timer_start(timer2)

  foreach(i RANGE 0 100)
    nav("a.b.c")
    ans(res)
  endforeach()

  timer_print_elapsed(timer2)




endfunction()







function(test)


  function(query_literal_test literal)
    data("${literal}")
    ans(literal)
    timer_start(query_literal_timer)
    query_literal("${literal}" __mypredicate)
    ans(predicate)
    __mypredicate(${ARGN})
    ans(res)
    timer_print_elapsed(query_literal_timer)

    #call2("${predicate}" ${ARGN})
    return_ref(res)
  endfunction()


  define_test_function(test_uut query_literal_test literal)


  test_uut("true" "a" "a")
  test_uut("false" "a" "b")
  test_uut("true" "true" "akakaka")
  test_uut("false" "true" "NOTFOUND")
  test_uut("true" "false" "NOTFOUND")
  test_uut("false" "false" "akakaka")
  test_uut("true" "{match:'abc'}" "jdhakabcasd")
  test_uut("false" "{match:'yzy'}" "jdhakabcasd")



endfunction()
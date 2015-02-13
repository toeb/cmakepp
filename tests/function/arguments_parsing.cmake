function(test)


  invocation_argument_string()
  ans(res)
  assert("${res}_" STREQUAL "_")

  invocation_argument_string("a")
  ans(res)
  assert("${res}_" STREQUAL "a_")

  invocation_argument_string("a;b;c" d)
  ans(res)
  assert("${res}" EQUALS "\"a;b;c\" d")

  invocation_argument_string("")
  ans(res)
  assert("${res}" STREQUAL "\"\"")


  invocation_argument_string("" "" a "" )
  ans(res)
  assert("${res}" STREQUAL "\"\" \"\" a \"\"")

  invocation_argument_string(asdasd("1;2;3" a b c))
  ans(res)
  assert("[${res}]" STREQUAL "[asdasd ( \"1;2;3\" a b c )]")

  invocation_argument_encoded_list(adasda("1;2;3" a b c))
  ans(res)


endfunction()
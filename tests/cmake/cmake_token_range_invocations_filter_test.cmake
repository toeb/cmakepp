function(test)
  cmake_token_range_invocations_filter("function(ddd)\nasd(dasd)\nendfunction()\nset(a b c d e f g)" true --skip 1 --take 2)
  ans(res)
  assertf("{res[0].invocation_identifier}" STREQUAL asd)
  assertf("{res[0].invocation_token.value}" STREQUAL "asd" )
  assertf("{res[1].invocation_identifier}" STREQUAL endfunction)
  assertf("{res[0].invocation_arguments}" EQUALS dasd)
  assertf("{res[1].invocation_arguments}" ISNULL)


  cmake_token_range_invocations_filter("function(ddd)\nasd(dasd)\nendfunction()\nset(a b c d e f g)" {invocation_identifier} STREQUAL "asd")
  ans(res)
  assertf("{res[0].invocation_identifier}" STREQUAL asd)


endfunction()
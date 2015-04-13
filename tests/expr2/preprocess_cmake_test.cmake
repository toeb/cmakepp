function(test)

  function(you)
    cmakepp_enable_expressions("${CMAKE_CURRENT_LIST_LINE}")
    message("so this is a test to look if it works $[test::string_length()]")
    return("$[test::string_length()]")
  endfunction()


  message("so this is a test to look if it works $[test::string_length()]")

  you()
  ans(res)
  assert("${res}" EQUAL 4)


endfunction()
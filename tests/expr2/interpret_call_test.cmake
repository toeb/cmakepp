function(test)
set(exception "{'__$type__':'exception'}")

   function(my_func)
    arguments_encoded_list(0 ${ARGC})
    ans(result)

    list(INSERT result 0 my_func)
    #_message("${result}")
    return_ref(result)
  endfunction()
  set(thefunc my_func)

  string_codes()
  ##### runtime tests #####

  ## interpret call tests
  define_test_function2(test_uut eval_expr2 interpret_call "--print-code")


  test_uut("${exception}")  # no token
  test_uut("${exception}" "")  # empty token
  test_uut("${exception}" "abc")  # no paren -> no call 
  test_uut("${exception}" "()")  # no lhs rvalue
  test_uut("${exception}" "()()") ## illegal lhs rvalue  
 

  ## static functions
  test_uut("my_func" "my_func()")
  test_uut("my_func;1" "my_func(1)")
  test_uut("my_func;1;2" "my_func(1,2)")
  test_uut("my_func;1;2;3" "my_func(1,2,3)")

  test_uut("my_func;1;2${semicolon_code}3;4" "my_func(1,[2,3],4)") 
  test_uut("my_func;my_func${semicolon_code}my_func" "my_func(my_func(my_func()))") 

  ## elipsis
  test_uut("my_func;1;2;3" "my_func(1,[ 2 , 3]...)")

  ## dynamic function

  test_uut("my_func" "$thefunc()")
  test_uut("my_func;1" "$thefunc(1)")
  test_uut("my_func;1${semicolon_code}2;3${semicolon_code}4" "$thefunc([1,2],[3,4])")

endfunction()
function(test)
  function(test_cmake_ast code)
    timer_start(cmake_ast)
    cmake_ast("${code}")
    ans(res)
    timer_print_elapsed(cmake_ast)

    return_ref(res)
  endfunction()

  define_test_function(test_uut test_cmake_ast code)

  test_uut("{command_definitions:{invocation_type:'command_definition'}}" "   function(ttest) \nmessage(hello) \nendfunction()")
  test_uut("{command_definitions:{name:'ttest'}}" "   function(ttest) \nmessage(hello) \nendfunction()")


  function(cmake_token_range_extract_arguments start)
    
    cmake_tokens("${start}")
    ans(start)
    list_peek_front(start)
    ans(start)

    set(current ${start})
    set(result)

    map_tryget(${start} parent)
    ans(end)
    print_vars(current end)
    while(true)
      if(NOT current)
        return()
      endif()
      token_find_next_type("${current}" "(unquoated_argument)|(quoated_argument)|(nesting_end)")
      ans(current)

      print_vars(current)
      map_tryget(${current} literal_value)
      ans_append(result)
      message("${result}")
      
      if("${current}" STREQUAL "${end}")
        return_ref(result)
      endif()
      
      map_tryget(${current} next)
      ans(current)
    endwhile()  
  endfunction()

  cmake_token_range_extract_arguments("(hello world)")
  ans(res)
  message("${res}")

  return()




endfunction()
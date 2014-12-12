function(test)


  command_line_escape(a b c "hallo du" "asdfdef" "lalala\"\"")
  ans(res)

  assert(${res} a b c "\"hallo du\"" asdfdef "\"lalala\\\"\\\"\"" ARE_EQUAL)






  function(process_start_info_parse_list)

#    command_line_escape(${ARGN})
 #   ans(args)
    set(args ${ARGN})

    list_pop_front(args)
    ans(command)

    map_capture_new(command args)
    return_ans()
  endfunction()



  process_start_info_parse_list(test )
  ans(res)
  assertf("{res.args}" ISNULL)
  assertf("{res.command}" "test" ARE_EQUAL)

  process_start_info_parse_list(test a b c)
  ans(res)
  assertf("{res.args}" a b c ARE_EQUAL)
  assertf("{res.command}" "test" ARE_EQUAL)

  process_start_info_parse_list(test "a b" c "d e")
  ans(res)
  assertf("{res.args}" ARE_EQUAL "a b" c "d e")
  assertf("{res.command}" "test" ARE_EQUAL)


  process_start_info_parse_list(test a "\"\"" c)
  ans(res)
  assertf("{res.args}" ARE_EQUAL a "\"\"" c)
  assertf("{res.command}" "test" ARE_EQUAL)

function(string_take_commandline_arg __string_take_commandline_arg_string_ref)
  string_take_regex(${__string_take_commandline_arg_string_ref} " *(\"([^\"]|\\\")*\"|[^ ])")
  ans(__string_take_commandline_arg_result)
  string_take_whitespace(__string_take_commandline_arg_result)
  set("${__string_take_commandline_arg_string_ref}" "${${__string_take_commandline_arg_string_ref}}" PARENT_SCOPE)
  return_ref(__string_take_commandline_arg_result)
endfunction()

  function(process_start_info_parse_string str)
    uri_parse("${str}")
    ans(url)

    json_print(${url})
    map_tryget(${url} rest)
    ans(rest)   

    map_tryget(${url} undelimited)
    ans(command)

    set(args)
    while(true)
      string_take_commandline_arg(rest)
      ans(arg)
      list(APPEND args "${arg}")
      if("${arg}_" STREQUAL "_")
        break()
      endif()
    endwhile()

    map_capture_new(command args)
    return_ans()
  endfunction()


  process_start_info_parse_string("test a b c")
  ans(res)
  assertf("{res.command}" STREQUAL "test")
  assertf("{res.args}"  a b c ARE_EQUAL)



  process_start_info_parse_string("'c:\\test j\\ads.exe' a b c")
  ans(res)
  assertf("{res.command}"  "c:\\test j\\ads.exe" ARE_EQUAL)
  assertf("{res.args}"  a b c ARE_EQUAL)

  json_print(${res})





return()


  function(process_start_info)

    command_line_escape(${ARGN})
    ans(escaped)





    map_capture_new()
    ans(res)
    json_print(${res})
    return_ref(res)

  endfunction()


  process_start_info("hello")
 

 return()

  #process start info for a  simple command
  process_start_info("{command:'thecommand'}")
  ans(res)
  assert(res)
  assert(DEREF "{res.command}" STREQUAL "thecommand")


  # process start info for a command
  process_start_info("thecommand")
  ans(res)
  assert(res)
  assert(DEREF "{res.command}" STREQUAL "thecommand")


  process_start_info("{command_string:'thecommand arg1 arg2 arg3'")
  ans(res)
  assert(res)
  assert(DEREF "{res.command}" STREQUAL "thecommand")
  assert(DEREF EQUALS {res.args}  arg1 arg2 arg3)
  assert(DEREF "{res.command_string}" STREQUAL "thecommand arg1 arg2 arg3")
  assert(DEREF "{res.arg_string}" STREQUAL "arg1 arg2 arg3")

  process_start_info("{command:'thecommand', args:['arg1','arg2', 'arg3']}")
  ans(res)
  assert(res)
  assert(DEREF "{res.command}" STREQUAL "thecommand")
  assert(DEREF "{res.command_string}" STREQUAL "thecommand arg1 arg2 arg3")
  assert(DEREF EQUALS {res.args} arg1 arg2 arg3) 


  process_start_info("{command:'thecommand', arg_string:'arg1 arg2 arg3']")
  ans(res)
  assert(res)
  assert(DEREF "{res.command_string}" STREQUAL "thecommand arg1 arg2 arg3") 
  assert(DEREF "{res.arg_string}" STREQUAL "arg1 arg2 arg3")
  assert(DEREF EQUALS "{res.args}" arg1 arg2 arg3)

  process_start_info("thecommand a b c")
  ans(res)
  assert(res)
  assert(DEREF "{res.command_string}" STREQUAL "thecommand a b c")
  assert(DEREF "{res.arg_string}" STREQUAL "a b c")
  assert(DEREF EQUALS "{res.args}" a b c )
  assert(DEREF "{res.command}" STREQUAL "thecommand")



  process_start_info("/a/program files/test a b c")
  ans(res)
  assert(res)
  assert(DEREF "{res.command}" STREQUAL "/a/program files/test")
  assert(DEREF EQUALS {res.args} a b c)

  process_start_info("thecommand \"asd bsd\" asd \"ddd\"")
  ans(res)


endfunction()
function(test)

  function(string_take_commandline_arg str_ref)
    string_take_whitespace(${str_ref})
    set(regex "(\"([^\"\\\\]|\\\\.)*\")|[^ ]+")
    string_take_regex(${str_ref} "${regex}")
    ans(res)
    if(NOT "${res}_" STREQUAL _)
      set("${str_ref}" "${${str_ref}}" PARENT_SCOPE)
    endif()
    if("${res}" MATCHES "\".*\"")
      string_take_delimited(res "\"")
      ans(res)
    endif()

    return_ref(res)


  endfunction()


  set(str "aa bb cc \"d e\" f \"ll\\\"oo\"")
  string_take_commandline_arg(str)
  ans(res)
  assert("${res}" STREQUAL "aa")
  string_take_commandline_arg(str)
  ans(res)
  assert("${res}" STREQUAL "bb")
  string_take_commandline_arg(str)
  ans(res)
  assert("${res}" STREQUAL "cc")
  string_take_commandline_arg(str)
  ans(res)
  assert("${res}" STREQUAL "d e")

  string_take_commandline_arg(str)
  ans(res)
  assert("${res}" STREQUAL "f")

  string_take_commandline_arg(str)
  ans(res)
  assert("${res}" STREQUAL "ll\"oo")

  command_line_escape(a b c "hallo du" "asdfdef" "lalala\"\"")
  ans(res)

  assert(${res} a b c "\"hallo du\"" asdfdef "\"lalala\\\"\\\"\"" ARE_EQUAL)






  function(command_line_parse)
    set(args ${ARGN})

    list_pop_front(args)
    ans(command)

    command_line_parse_string("${command}")
    ans(res)

    if(NOT "${args}_" STREQUAL "_")
      map_append(${res} args ${args})
    endif()

    return_ans()
  endfunction()

  function(command_line_parse_string str)
    uri_parse("${str}")
    ans(uri)

    map_tryget(${uri} rest)
    ans(rest)   

    uri_to_localpath("${uri}")
    ans(command)
    
    set(args)
    while(true)
      string_take_commandline_arg(rest)
      ans(arg)
      string_parse_delimited("${arg}")
      ans(arg)

      list(APPEND args "${arg}")
      if("${arg}_" STREQUAL "_")
        break()
      endif()
    endwhile()

    map_capture_new(command args)
    return_ans()
  endfunction()



  define_test_function(test_uut command_line_parse)  

  test_uut("{command: 'test' ,args:null}" 
    test)
  test_uut("{command: 'test' ,args:['a', 'b', 'c']}"
   test a b c)
  test_uut("{command: 'test' ,args:['a b', 'c','d e']}"
   test "a b" c "d e")


  define_test_function(test_uut command_line_parse_string)

  test_uut(
    "{command:'test', args:['a','b','c']}" 
    "test a b c"
    )
  test_uut(
    "{command:'c:/my/path/to/command.exe', args:['a b', 'c','d']}"
    "c:\\my\\path\\to\\command.exe \"a b\" c d"
    )  

  test_uut(
    "{command:'../asd', args:[
      'ab',
      'bc',
      'c d',
      'e',
      'lll ooko',
      'f',
      'g'

    ]}"
    "../bsd/../asd ab bc \"c d\" e \"lll ooko\" f g"
    )

  test_uut(
    "{command:'a b', args:['c','d','e']}"
    "'a b'" c d e)


return()

  process_start_info_parse_string("/test/ a b c")
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
function(test)


  # fail test  
 # process_start_info("{}")
 # process_start_info("")


 function(string_take_path string_ref)

 endfunction()


 

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


  process_start_info("thecommand \"asd bsd\" asd \"ddd\")
  ans(res)


endfunction()
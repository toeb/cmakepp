function(test)


  new(command_line_handler mycommandrunner)
  ans(uut)


  function(cmd1)
    return(1 ${ARGN})
  endfunction()
  function(cmd2)
    return(2)
  endfunction()
  function(cmd3)
    return(3)
  endfunction()

  assign(uut.handlers[] = 'cmd1')
  assign(uut.handlers[] = 'cmd2')
  assign(uut.handlers[] = 'cmd3')
  assign(uut.handlers[] = "{callable:$uut, labels:'cmd4'}")

  assign(handlers = uut.handlers)


  assign(handler = uut.find_handler(cmd1 asd bsd))

  assign(res1 = uut(cmd4 cmd1 asd asd))
  json_print(${res})

  new(command_line_handler)
  ans(uut)

  function(the_view req res)
    assign(res.model = 'hellothere')
    assign(res.view = "'The result is the following `{model}`'")
  endfunction()



endfunction()
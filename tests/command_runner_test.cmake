function(test)

  macro(return_nav)
    assign(result = ${ARGN})
    return_ref(result)
  endmacro()
  macro(return_data data)
    data("${data}")
    return_ans()
  endmacro()

  function(command_runner)
    this_set(name "${ARGN}")

    ## forwards the object call operation to the run method
    this_declare_call(call)
    function(${call})
      obj_member_call(${this} run ${ARGN})
      return_ans()
    endfunction()

    ## executes the runner once
    ## routing the values to the 
    ## correct overload
    method(run)
    function(${run})
      set(args ${ARGN})
      assign(!context.input = args)
      assign(handler = this.find_handler(${context}))
      list(LENGTH handler handler_count)
      print_vars(handler args context)
      if(${handler_count} GREATER 1)
        return_data("{error:'ambiguous_handler',description:'multiple command handlers were found for the request',context:$context}" )
      endif()

      if(NOT handler)
        return_data("{error:'no_handler',description:'command runner could not find an appropriate handler for the specified arguments',context:$context}")
      endif() 

      assign(result = this.execute_handler(${handler} ${context}))
      if(NOT result)
        data("{error:'execution_error',description:'failed to execute handler'}")
        ans(result)
      endif()
      return_ref(result)

    endfunction()


    method(run_interactive)
    function(${run_interactive})
      if(NOT ARGN)
        echo_append("please enter a command>")
        read_line()
        ans(command)
      else()
        echo("executing command '${ARGN}':")
        set(command "${ARGN}")
      endif()
      obj_member_call(${this} run ${command})
      ans(res)
      table_serialize(${res})
      ans(formatted)
      echo(${formatted})
      return_ref(res)
    endfunction()

    ## compares the request to the handlers
    ## returns the handlers which matches the handler
    ## can return multiple handlers
    method(find_handler)
    function(${find_handler} context)
      message("find handler")

      json_print(${context})
      assign(result = context.input)
      print_vars(result)
      assign(result = "{callable:$result}")
      return_ref(result)
    endfunction()

    method(execute_handler)
    function(${execute_handler} handler context)
      message("execute handler")
      json_print("${context}")
      json_print(${handler})
      assign(data = context.input)
      assign(callable = handler.callable)
      print_vars(callable)
      call(${callable}(${context}))
      return_ans()
    endfunction()

    ## adds a request handler to this command handler
    ## request handler can be any function/function definition 
    ## or handler object
    method(add_handler)
    function(${add_handler})
      set(name ${ARGN})

      assign(handler = "{
        id:$name,
        display_name:$name,
        callable:$name
        args:''
      }")

      map_append(${this} handlers ${handler})
      
      return(${handler})
    endfunction()

  property(handlers)
  function(${set_handlers} obj key new_handlers)
    map_tryget(${this} handlers)
    ans(old_handlers)
    if(old_handlers)
      list(REMOVE_ITEM new_handlers ${old_handlers})
    endif()
    set(result)
    foreach(handler ${new_handlers})
      set_ans()
      obj_member_call(${this} add_handler ${handler})
      ans(res)
      list(APPEND result ${res})
    endforeach()
    return_ref(result)
  endfunction()

  function(${get_handlers})
    map_tryget(${this} handlers)
    return_ans()
  endfunction()



endfunction()



  function(handler handler)
    data(${handler})
    ans(handler)
    map_isvalid(${handler})
    ans(is_map)
    if(is_map)  
      map_tryget(${handler} callable)
      ans(callable)
      if(NOT COMMAND ${callable})
        return()
      endif()
      return(${handler})
    endif()

    if(COMMAND "${handler}")
      set(callable ${handler})
    else()
      function_new()
      ans(callable)
      function_import(${handler} as ${callable} REDEFINE)
      set(callable ${callable})
    endif()
    map_capture_new(
      callable
    )
    return_ans()
  endfunction()

  ## add a callable object handler

  ## add a a handler object

  ## executes a handler
  function(handler_execute handler request)
    handler(${handler})
    ans(handler)
    data(${request})
    ans(request)
    data(${ARGN})
    ans(response)
    if(NOT response)
      data("{output:''}")
      ans(reponse)
    endif()
    if(NOT handler)
      assign(!response.error = 'handler_invalid')
      assign(!response.message = "'handler was not valid'")
    else()
      assign(!response.handler = handler)
      map_tryget(${handler} callable)
      ans(callable)
      call(${callable}(${request} ${response}))
      ans(result)
    endif()
    return_ref(response)
  endfunction()


  function(handler_match handler request)
    map_tryget(${handler} labels)
    ans(labels)

    map_tryget(${request} input)
    ans(input)

    list_pop_front(input)
    ans(cmd)

    list_contains(labels "${cmd}")
    ans(is_match)
    return_ref(is_match)
  endfunction()
  
  function(handler_find handler_lst request)
    list_where(${handler_lst} "(handler)-> handler_match($handler ${request})")
    return_ans()
  endfunction()



  function(assert_equal expected)
    assign(expected = ${expected})
    assign(actual = ${ARGN})
    map_match("${actual}" "${expected}")
    ans(result)
    if(NOT result)
      echo_append("expected: ")
      json_print(${expected})
      echo_append("actual:")
      json_print(${actual})
      _message(FATAL_ERROR "values did not match")
    endif()
  endfunction()


  ## handler find test
  assign(handlers = "[
{callable: 'test_func', display_name: 'command1', id:'1', labels:'cmd1'},
{callable: 'test_func', display_name: 'command2', id:'2', labels:'cmd2'},
{callable: 'test_func', display_name: 'command3', id:'3', labels:['cmd3','cmd_3']}
    ]")

  #assign(result = handler_find(handlers "{input:['cmd2','b','c']}"))

  assert_equal("handlers[1]" handler_find(handlers "{input:['cmd2','b','c']}"))



  ## handler execute test
  function(test_func request response)
    assign(response.output += request.input)
  endfunction()

  ## valid handler func
  assert_equal("{output:'asdasdf',handler:{callable:'test_func'}}" handler_execute("{callable:'test_func'}" "{input:'asdf'}" "{output:'asd'}"))
  ## invalid handler func
  assert_equal("{output:'asd', error:'handler_invalid'}" handler_execute("{callable:'non_existent_func'}" "{input:'asdf'}" "{output:'asd'}"))


  ## on the fly handler
  handler_execute("(req res)-> map_set($res output yaaay)" "{}")
  ans(res)
  assert_equal("{output:'yaaay'}" res)



  handler("(req res)-> map_set($res output yaaay)")
  ans(handler)
  assign(req = "{}")
  assign(res = "{}")
  foreach(i RANGE 100)
  handler_execute("${handler}" "${req}" "${res}")

  endforeach()


  return()





endfunction()
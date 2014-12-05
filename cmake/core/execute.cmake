
  # input:
  # {
  #  <path:<executable>>, // path to executable or executable name -> shoudl be renamed to command
  #  <args:<arg ...>>,        // command line arguments to executable, use string_semicolon_encode() on an argument if you want to pass an argument with semicolons
  #  <?timeout:<seconds>],            // timout
  #  <?cwd:<unqualified path>>,                // current working dir (default is whatever pwd returns)
  #
  # }
  # returns:
  # {
  #   path: ...,
  #   args: ...,
  #   <timeout:<seconds>> ...,
  #   <cwd:<qualified path>> ...,
  #   output: <string>,   // all output of the process (stderr, and stdout)
  #   result: <int>       // return code of the process (normally 0 indicates success)
  # }
  #
  #
  function(execute processStart)
    obj("${processStart}")
    ans(processStart)
  
    map_clone_deep(${processStart})
    ans(processResult)

    map_get(${processStart} "path")
    ans(path)

    ## check if path exists if not search using find_path
    if(NOT path)
      message(FATAL_ERROR "no executable given")
    endif()

    map_tryget(${processStart} "args")
    ans(args)

    map_tryget(${processStart} "timeout")
    ans(timeout)

    if(timeout)
      set(timeout TIMEOUT ${timeout})
    else()
      map_set(${processResult} timeout -1)
    endif()

    map_tryget(${processStart} "cwd")
    ans(cwd)

    #get_filename_component(cwd "${cwd}" REALPATH)
    path("${cwd}")
    ans(cwd)

    if(cwd)
      if(NOT IS_DIRECTORY "${cwd}")
        file(MAKE_DIRECTORY "${cwd}")
      endif()
      map_set(${processResult} cwd "${cwd}")
      set(cwd WORKING_DIRECTORY ${cwd})
    endif()


    # now compile the command string and evaluate
    # this allows using encoded semicolons
    set(argstring)
    foreach(arg ${args})
      cmake_string_escape("${arg}")
      ans(arg)
      
      string_semicolon_decode("${arg}")
      ans(arg)      


      set(argstring "${argstring} \"${arg}\"")
      
    endforeach()

    set(execute_process_command "
        execute_process(
          COMMAND \"\${path}\" ${argstring}
          \${timeout}
          \${cwd}
          RESULT_VARIABLE result
          OUTPUT_VARIABLE output
          ERROR_VARIABLE output
        )

        map_set(\${processResult} output \"\${output}\")
        map_set(\${processResult} result \"\${result}\")
    ")

     
    eval("${execute_process_command}")


    if(OOCMAKE_DEBUG_EXECUTE)
      json_print(${processResult})
    endif()

    return(${processResult})
  endfunction()
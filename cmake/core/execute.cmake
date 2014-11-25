
  # input:
  # {
  #  path:<executable_path>, // path to executable
  #  args:<args ...>,        // command line arguments to executable
  #  [timeout: ],            // timout
  #  [cwd: ],                // current working dir (default is whatever pwd returns)
  #
  # }
  # returns:
  # {
  #   path: ...,
  #   args: ...,
  #   timeout: ...,
  #   cwd: ...,
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

    get_filename_component(cwd "${cwd}" REALPATH)

    if(cwd)
      if(NOT IS_DIRECTORY "${cwd}")
        file(MAKE_DIRECTORY "${cwd}")
      endif()
      map_set(${processResult} cwd "${cwd}")
      set(cwd WORKING_DIRECTORY ${cwd})
    endif()

    execute_process(
      COMMAND "${path}" ${args}
      ${timeout}
      ${cwd}
      RESULT_VARIABLE result
      OUTPUT_VARIABLE output
      ERROR_VARIABLE output
    )

  
    
    map_set(${processResult} output "${output}")
    map_set(${processResult} result "${result}")

    return(${processResult})
  endfunction()
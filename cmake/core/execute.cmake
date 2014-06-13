
  # {
  #  path:<executable_path>,
  #  args:<args ...>,
  #  [timeout: ],
  #  [cwd: ],
  #  
  # } 
  #
  function(execute processStart)
    obj("${processStart}")
    ans(processStart)

    map_get(${processStart} "path")
    ans(path)

    map_tryget(${processStart} "args")
    ans(args)

    map_tryget(${processStart} "timeout")
    ans(timeout)

    if(timeout)
      set(timeout TIMEOUT ${timeout})
    endif()

    map_tryget(${processStart} "cwd")
    ans(cwd)

    get_filename_component(cwd "${cwd}" REALPATH)

    if(cwd)
      if(NOT IS_DIRECTORY "${cwd}")
        file(MAKE_DIRECTORY "${cwd}")
      endif()
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

    map_clone_deep(${processStart})
    ans(processResult)

    map_set(${processResult} output "${output}")
    map_set(${processResult} result "${result}")

    return(${processResult})
  endfunction()
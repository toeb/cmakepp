## refreshes the fields of the process handle
## returns true if the process is still running false otherwise
## this is the only function which is allowed to change the state of a process handle
function(process_refresh_handle handle)
  process_handle("${handle}")
  ans(handle)


  set(args ${ARGN})

  process_isrunning("${handle}")
  ans(isrunning)





  if(isrunning)
    set(state running)
  else()
    set(state terminated)
  endif()

  # get old state update new state
  map_tryget(${handle} state)
  ans(previous_state)
  map_set(${handle} state "${state}")


  if(NOT "${state}_" STREQUAL "${previous_state}_")
    #message(FORMAT "statechange ({handle.pid}) : {previous_state} -> {state} ")
    if("${state}" STREQUAL "terminated")
      process_return_code("${handle}")
      ans(return_code)
      process_stdout("${handle}")
      ans(stdout)
      process_stderr("${handle}")
      ans(stderr)
      map_capture("${handle}" return_code stdout stderr)
    endif()
  endif()

  return(${isrunning})

endfunction()

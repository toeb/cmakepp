function(test)

  ## fork a process and wait 
  process_fork("{command:'sleep',args:'4'}") 
  ans(handle)

  process_wait(${handle})
  ans(res)

  assert(res)
  assert("${res}" STREQUAL "${handle}")
  assert(DEREF {res.state} STREQUAL "terminated")
  assert(DEREF {res.return_code} STREQUAL "0")


  ## arrange 

  # create process which runs long
  process_fork_script("execute_process(sleep 40)\nmessage(hello)")
  ans(handle)

  process_wait(${handle} 3)
  ans(failed_to_time_out)


  process_kill(${handle})

  process_wait(${handle} 5)
  ans(successfully_stopped_before_timeout)

  dbg(failed_to_time_out)
  dbg(successfully_stopped_before_timeout)

  assert(NOT failed_to_time_out AND successfully_stopped_before_timeout)

endfunction()
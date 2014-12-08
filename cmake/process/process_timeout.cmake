## returns a <process handle> to a process that runs for n seconds
function(process_timeout n)
  set(script "
    foreach(i RANGE 0 ${n})
      execute_process(COMMAND \${CMAKE_COMMAND} -E sleep 1)
    endforeach()
  ")
  return_ans()
endfunction()
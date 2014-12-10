## returns a <process handle> to a process that runs for n seconds
#todo create shims
function(process_timeout n)
  if(${CMAKE_MAJOR_VERSION} GREATER 2)
    process_fork("{command:$CMAKE_COMMAND, args:['-E', 'sleep', $n]}")
    return_ans()
  else()
    if(UNIX)
      process_fork("{command:'sleep', args:$n}")
      return_ans()
    endif()
  endif()
endfunction()
## returns a <process handle> to a process that runs for n seconds
#todo create shims
function(process_timeout n)
  if(${CMAKE_MAJOR_VERSION} GREATER 2)
    execute(${CMAKE_COMMAND} -E sleep ${n} --async)
    return_ans()
  else()
    if(UNIX)
      execute(sleep ${n} --async)
      return_ans()
    endif()
  endif()
endfunction()
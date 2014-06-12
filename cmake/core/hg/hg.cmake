function(hg)
  find_package(Hg)
  if(NOT HG_FOUND)
    message(FATAL_ERROR "mercurial is not installed")
  endif()

  function(hg)
    pwd()
    ans(cwd) 

    if(NOT IS_DIRECTORY "${cwd}")
      message(FATAL_ERROR "${cwd} is not a directory, try setting it via cd()")
    endif()

    set(args ${ARGN})



    execute("{
      path:$HG_EXECUTABLE,
      args:$args,
      cwd:$cwd

    }")
    ans(execution_result)
    
    if(_--result)
      return(${execution_result})
    endif()

    nav(error = execution_result.result)
    if(error)
      return()
    endif()

    nav(stdout = execution_result.output)
    return_ref(stdout)
  endfunction()
  hg(${ARGN})
  return_ans()
endfunction()
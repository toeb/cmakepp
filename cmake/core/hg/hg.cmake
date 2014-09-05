# convenience function for accessing hg
# use cd() to navigate to working directory
# usage is same as hg command line client
# syntax differs: hg arg1 arg2 ... -> hg(arg1 arg2 ...)
# add a --result flag to get a object containing return code
# input args etc.
# else only console output is returned
function(hg)
  find_package(Hg)
  if(NOT HG_FOUND)
    message(FATAL_ERROR "mercurial is not installed")
  endif()

 wrap_executable(hg "${HG_EXECUTABLE}")
 hg(${ARGN})
 return_ans()

# old implementation
  function(hg)
    pwd()
    ans(cwd) 

    if(NOT IS_DIRECTORY "${cwd}")
      message(FATAL_ERROR "${cwd} is not a directory, try setting it via cd()")
    endif()

    set(args ${ARGN})
    list_extract_flag(args --result)
    ans(result_flag)


    execute("{
      path:$HG_EXECUTABLE,
      args:$args,
      cwd:$cwd

    }")
    ans(execution_result)
    
    if(result_flag)
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
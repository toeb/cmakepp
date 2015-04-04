## a fast wrapper for the specified executable
## this should be used for executables that are called often
## and do not need to run async
function(wrap_executable_bare alias executable)

  eval("
    function(${alias})
      pwd()
      ans(cwd)
      #message(\"\${ARGN}\")
      execute_process(COMMAND \"${executable}\" ${ARGN} \${ARGN}
        WORKING_DIRECTORY  \"\${cwd}\"
        OUTPUT_VARIABLE stdout 
        ERROR_VARIABLE stdout 
        RESULT_VARIABLE error
      )
      list(INSERT stdout 0 \${error})
      return_ref(stdout)
    endfunction()
    ")
  return()
endfunction()
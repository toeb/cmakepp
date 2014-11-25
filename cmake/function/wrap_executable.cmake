# creates a function called ${alias} which wraps the executable specified in ${executable}
# the alias function's varargs will be passed on as command line arguments. 
# if you specify --result the function will return a the execution result object (see execute()) 
# if you specify --return-code the function will return the returncode
# else only the application output will be returned 
# and if the application terminates with an exit code != 0 a fatal error will be raised
  function(wrap_executable alias executable)
    set_ans("")
    eval("  
      function(${alias})
        pwd()
        ans(cwd)
        if(NOT IS_DIRECTORY \"\${cwd}\")
          message(FATAL_ERROR \"${alias}: '\${cwd}' is not a directory, try setting it via cd()\")
        endif()
        set(args \${ARGN})
        list_extract_flag(args --result)
        ans(result_flag)
        list_extract_flag(args --return-code)
        ans(return_code_flag)
        set(executable \"${executable}\")
        execute(\"{
          path:$executable,
          args:$args,
          cwd:$cwd
        }\")
        ans(execution_result)
        if(result_flag)
          return(\${execution_result})
        endif()

        map_tryget(\${execution_result} result)
        ans(error)

        if(return_code_flag)
          return_ref(error)
        endif()

        if(NOT \"\${error}\" EQUAL 0)
          message(FATAL_ERROR \"failed to execute ${alias} - return code is '\${error}'\")
          return()
        endif()

        map_tryget(\${execution_result} output)
        return_ans()
      endfunction()
      ")
    return()
  endfunction()

# wrap_executable(<alias> <executable> <args...>)-><null>
#
# creates a function called ${alias} which wraps the executable specified in ${executable}
# <args...> will be set as command line arguments for every call
# the alias function's varargs will be passed on as command line arguments. 
#
# Warning: --async is a bit experimental
#
# defines function
# <alias>([--async]|[--result]|[--return-code])-> <stdout>|<process result>|<return code>|<process handle>
#
# <no flag>       if no flag is specified then the function will fail if the return code is not 0
#                 if it succeeds the return value is the stdout
#
# --result        flag the function will return a the execution 
#                 result object (see execute()) 
# --return-code   flag the function will return the returncode
# --async         will execute the executable asynchroniously and
#                 return a <process handle>
# --async-wait    will execute the executable asynchroniously 
#                 but will not return until the task is finished
#                 printing a status indicator
# 
# else only the application output will be returned 
# and if the application terminates with an exit code != 0 a fatal error will be raised
function(wrap_executable alias executable)
  set_ans("")

  set(predefined_arg_string)
  foreach(arg ${ARGN})
    set(predefined_arg_string "${predefined_arg_string} \"${arg}\"")
  endforeach()

  eval("  
    function(${alias})
      pwd()
      ans(cwd)
      if(NOT IS_DIRECTORY \"\${cwd}\")
        message(FATAL_ERROR \"${alias}: '\${cwd}' is not a directory, try setting it via cd()\")
      endif()
      set(cmd_line_args ${predefined_arg_string} \${ARGN})
      list_extract_flag(cmd_line_args --result)
      ans(result_flag)
      list_extract_flag(cmd_line_args --return-code)
      ans(return_code_flag)
      list_extract_flag(cmd_line_args --async)
      ans(async)
      list_extract_flag(cmd_line_args --async-wait)
      ans(wait)

      set(executable \"${executable}\")

      if(async OR wait)
        process_start(\"{
          path:$executable,
          args:$cmd_line_args,
          cwd:$cwd
        }\")
        ans(process_handle)
        if(NOT wait)
          return_ref(process_handle)
        endif()

        get_filename_component(name \${executable} NAME_WE)

        echo_append(\"waiting for \${name} process to finish ...\")
        set(is_running true)
        while(is_running)
          tick()
          process_refresh_handle(\${process_handle})
          ans(is_running)
        endwhile()
        message(\"... done\")
      else()
        execute(\"{
          path:$executable,
          args:$cmd_line_args,
          cwd:$cwd
        }\")
        ans(process_handle)   
      endif()

      if(result_flag)
        return(\${process_handle})
      endif()

      map_tryget(\${process_handle} return_code)
      ans(error)
      if(NOT error)
        set(error 0)
      endif()

      if(return_code_flag)
        return_ref(error)
      endif()
      map_tryget(\${process_handle} stdout)
      ans(stdout)

      if(NOT \"\${error}\" EQUAL 0)

        message(FATAL_ERROR \"failed to execute ${alias} - return code is '\${error}'\\n stderr:\\n \${stdout} \")

        return()
      endif()

      return_ref(stdout)
    endfunction()
    ")
  return()
endfunction()
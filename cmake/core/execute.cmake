
  # input:
  # {
  #  <path:<executable>>, // path to executable or executable name -> shoudl be renamed to command
  #  <args:<arg ...>>,        // command line arguments to executable, use string_semicolon_encode() on an argument if you want to pass an argument with semicolons
  #  <?timeout:<seconds>],            // timout
  #  <?cwd:<unqualified path>>,                // current working dir (default is whatever pwd returns)
  #
  # }
  # returns:
  # {
  #   path: ...,
  #   args: ...,
  #   <timeout:<seconds>> ...,
  #   <cwd:<qualified path>> ...,
  #   output: <string>,   // all output of the process (stderr, and stdout)
  #   result: <int>       // return code of the process (normally 0 indicates success)
  # }
  #
  #
  function(execute)
    set(args ${ARGN}) 
    
    # list_extract_flag(cmd_line_args --result)
    # ans(result_flag)
    # list_extract_flag(cmd_line_args --return-code)
    # ans(return_code_flag)
    # list_extract_flag(cmd_line_args --async)
    # ans(async)
    # list_extract_flag(cmd_line_args --async-wait)
    # ans(wait)
    
    
    #set(args ${ARGN})
    # todo - --result --return-code --async --async-wait --show-output

    process_start_info(${ARGN})
    ans(processStart)

    if(NOT processStart)
      return()
    endif()

    #obj("${processStart}")
  
    map_clone_deep(${processStart})
    ans(processResult)



    scope_import_map(${processStart})

    set(timeout TIMEOUT ${timeout})
    set(cwd WORKING_DIRECTORY "${cwd}")


    command_line_args_combine(${args})
    ans(arg_string)
    
    ## todo - test this
    string(REPLACE \\ \\\\ arg_string "${arg_string}")

    set(execute_process_command "
        execute_process(
          COMMAND \"\${command}\" ${arg_string}
          \${timeout}
          \${cwd}
          RESULT_VARIABLE result
          OUTPUT_VARIABLE output
          ERROR_VARIABLE output
        )

        map_set(\${processResult} output \"\${output}\")
        map_set(\${processResult} stdout \"\${output}\")
        map_set(\${processResult} result \"\${result}\")
        map_set(\${processResult} error \"\${result}\")
        map_set(\${processResult} return_code \"\${result}\")
    ")


     
    eval("${execute_process_command}")



    return(${processResult})
  endfunction()
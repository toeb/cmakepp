function(nohup)
    wrap_executable(nohup nohup)
    nohup(${ARGN})
    return_ans()
endfunction()
# process_fork implementation specific to linux
# uses bash and nohup to start a process 
function(process_fork_Linux process_start_info)
    process_start_info("${process_start_info}")
    ans(process_start_info)

    scope_import_map(${process_start_info})
    set(command_string "${command} ${arg_string}")



    # define output files        
      file_make_temporary("")
      ans(stdout)
      file_make_temporary("")
      ans(stderr)
      file_make_temporary("")
      ans(return_code)
      file_make_temporary("")
      ans(pid_out)

      # create a temporary shell script 
      # which starts bash with the specified command 
      # output of the command is stored in stdout file 
      # error of the command is stored in stderr file 
      # return_code is stored in return_code file 
      # and the created process id is stored in pid_out
      shell_tmp_script("( bash -c \"${command_string} > ${stdout} 2> ${stderr}\" ; echo $? > ${return_code}) & echo $! > ${pid_out}")
      ans(script)
      ## execute the script in bash with nohup 
      ## which causes the script to run detached from process
      bash(-c "nohup ${script} > /dev/null 2> /dev/null" --return_code)
      ans(error)

      if(error)
        message(FATAL_ERROR "could not start process '${command_string}'")
      endif()

      fread("${pid_out}")
      ans(pid)

      string(STRIP "${pid}" pid)

    process_handle("${pid}")
    ans(handle)

    ## set output of process
    nav(handle.stdout_file = stdout)
    nav(handle.stderr_file = stderr)
    nav(handle.return_code_file = return_code)

    process_refresh_handle("${handle}")

    return_ref(handle)
endfunction()

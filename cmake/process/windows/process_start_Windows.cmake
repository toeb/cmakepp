## windows implementation for start process
 function(process_start_Windows)
    process_start_info(${ARGN})
    ans(start_info)

    if(NOT start_info)
      message(WARNING "<process start info> could not be parsed from '${ARGN}'")
      return()
    endif()

    map_tryget(${start_info} command)
    ans(command)

    map_tryget(${start_info} args)
    ans(args)

    map_tryget(${start_info} cwd)
    ans(cwd)

    ## create temp dir where process specific files are stored
    mktemp()
    ans(dir)

    ## files where to store stdout and stderr
    set(outputfile "${dir}/stdout.txt")
    set(errorfile "${dir}/stderr.txt")
    set(returncodefile "${dir}/retcode.txt")
    set(pidfile "${dir}/pid.txt")
    fwrite("${outputfile}" "")
    fwrite("${errorfile}" "")
    fwrite("${returncodefile}" "")

    ## compile arglist
    win32_powershell_create_array(${args})
    ans(arg_list)

    ## The following script is a bit complex but it has to be to get the commands 
    ## pid,stdout, stderr and return_code correctly
    ## two instances of powershell need to be started for this to work correctly

    ## innerscript which starts the process  in ${cwd} using powershell's start-process command
    ## with redirected error and output streams
    ## it immediately writes the process id to ${pidfile}
    ## then it waits for process to finish
    ## after which it parses the exit code of said process
    set(inner "
      $j = start-process  -filepath '${command}'  -argumentlist ${arg_list} -passthru -redirectstandardout '${outputfile}' -redirectstandarderror '${errorfile}' -workingdirectory '${cwd}'
      $handle = $j.handle
      echo $j.id | out-file -encoding ascii -filepath '${pidfile}'
      wait-process -id $j.id
      $code = '[DllImport(\"kernel32.dll\")] public static extern int GetExitCodeProcess(IntPtr hProcess, out Int32 exitcode);'
      $type = Add-Type -MemberDefinition $code -Name \"Win32\" -Namespace Win32 -PassThru
      [Int32]$exitCode = 0
      $type::GetExitCodeProcess($j.Handle, [ref]$exitCode)
      echo $exitCode | out-file -encoding ascii -filepath '${returncodefile}'
      ")
    ## store innerscript so it can be called by outer script  
    fwrite("${dir}/inner.ps1" "${inner}")
    ans(inner_script)

    ## starts a new powershell process executing  the innerscript and exits 
    ## this wrapping is needed because redirectstandarderror and redirectstandardout 
    ## will cause powershell to wait for the stream to end which happens when the process is finished.
    ## hides the window 
    ## on execution you will notice that two windows open in quick succession
    set(outer "
        start-process -filepath powershell -argumentlist @('-NoLogo','-NonInteractive','-ExecutionPolicy','ByPass','-WindowStyle','Hidden','-File','${inner_script}')
        exit
      ")

    ## run script
    win32_powershell_run_script("${outer}")    
    ans(pid)

    ## wait until the pidfile exists and contains a valid pid
    ## this seems very hackisch but is necessary as i have not found
    ## a simpler way to do it
    while(true)
      if(EXISTS "${pidfile}")
        fread("${pidfile}")
        ans(pid)
        if("${pid}" MATCHES "[0-9]+" )
          break()
        endif()
      endif()
    endwhile()


    ## create a process handle from pid
    process_handle("${pid}")    
    ans(handle)

    
    ## set the output files for handle
    nav(handle.stdout_file = outputfile)
    nav(handle.stderr_file = errorfile)
    nav(handle.return_code_file = returncodefile)
    nav(handle.process_start_info = start_info)
    nav(handle.windows.process_data_dir = dir) 


    return_ref(handle)
  endfunction()


## old implementation with wmic
## does nto handle output and 
# function(process_start_Windows)
#   process_start_info(${ARGN})
#   ans(process_start_info)

#   if(NOT process_start_info)
#     return()
#   endif()

#   command_line_to_string(${process_start_info})
#   ans(command_line)
  
#   win32_fork(-exec "${command_line}" -workdir "${cwd}" --result)
#   ans(exec_result)
#   scope_import_map(${exec_result})
#   if(return_code)
#     json_print(${exec_result})
#     message(FATAL_ERROR "failed to fork process.  returned code was ${return_code} message:\n ${stdout}  ")
#   endif()

#   string(REGEX MATCH "[1-9][0-9]*" pid "${stdout}")
#   set(status running)
#   map_capture_new(pid process_start_info status)
#   return_ans()  
# endfunction()

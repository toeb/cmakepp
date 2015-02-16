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
      $j = start-process -NoNewWindow -filepath '${command}'  -argumentlist ${arg_list} -passthru -redirectstandardout '${outputfile}' -redirectstandarderror '${errorfile}' -workingdirectory '${cwd}'
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
        start-process -WindowStyle Hidden -filepath powershell -argumentlist @('-NoLogo','-NonInteractive','-ExecutionPolicy','ByPass','-WindowStyle','Hidden','-File','${inner_script}')
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



## windows implementation for start process
## newer faster version
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

    command_line_args_combine(${args})
    ans(arg_string)
    set(command_string "${command} ${arg_string}")

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


    ## creates a temporary batch file
    ## which gets the process id (get the parent process id wmic....)
    ## output pid to file output command_string to 
    file_tmp("bat" "
      @echo off
      wmic process get parentprocessid,name|find \"WMIC\" > ${pidfile}
      ${command_string} > ${outputfile} 2> ${errorfile}
      echo %errorlevel% > ${returncodefile}
      exit
    ")
    ans(path)
    win32_powershell("start-process -File ${path} -WindowStyle Hidden")


    ## wait until the pidfile exists and contains a valid pid
    ## this seems very hackisch but is necessary as i have not found
    ## a simpler way to do it
    while(true)
      if(EXISTS "${pidfile}")
        fread("${pidfile}")
        ans(pid)
        if("${pid}" MATCHES "[0-9]+" )
          set(pid "${CMAKE_MATCH_0}")
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

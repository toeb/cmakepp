function(test)

  function(test_execute_process test)
    message(STATUS "running test ${test}...")

    #initialize variables which test can use
    set(test_name "${test}")


    # setup a directory for the test
    string_normalize("${test}")
    ans(test_dir)
    oocmake_config(temp_dir)
    ans(temp_dir)
    set(test_dir "${temp_dir}/tests/${test_dir}")
    file(REMOVE_RECURSE "${test_dir}")
    get_filename_component(test_dir "${test_dir}" REALPATH)
    
    message(STATUS "test directory is ${test_dir}")  
    pushd("${test_dir}" --create)
    call("${test}"())
    ans(time)
    popd()
 
  endfunction()




  function(win32_cmd)
    wrap_executable(win32_cmd cmd.exe)
    win32_cmd(${ARGN})
    return_ans()
  endfunction()

  function(win32_bash)
    find_package(Cygwin QUIETLY)
    if(NOT Cygwin_FOUND)
      message(FATAL_ERROR "Cygwin was not found on your system")
    endif()
    wrap_exectuable(win32_bash "${Cygwin_EXECUTABLE}")
    win32_bash(${ARGN})
    return_ans()
  endfunction()




  function(win32_taskkill)
    wrap_executable(win32_taskkill "taskkill")
    win32_taskkill(${ARGN})
    return_ans()
  endfunction()
  
  ## wraps the windows task lisk programm which returns process info
  function(win32_tasklist)
    wrap_executable(win32_tasklist "tasklist")
    win32_tasklist(${ARGN})
    return_ans()
  endfunction()

  function(win32_fork)
    oocmake_config(base_dir)
    ans(base_dir)
      wrap_executable(win32_fork "${base_dir}/resources/exec_windows.bat")
    win32_fork(${ARGN})
    return_ans()
  endfunction()

  ## forks a process and returns a handle which can be used to controll it.  
  ##
  # {
  #   <pid:<unique identifier>> // some sort of unique identifier which can be used to identify the processs
  #   <process_start_info:<process start info>> /// the start info for the process
  #   <output:<function():<string>>>
  # }
  function(fork process_start_info)
    process_start_info("${process_start_info}")
    ans(process_start_info)

    scope_import_map(${process_start_info})

    if(WIN32)      

      
      win32_fork(-exec "${command} ${arg_string}" -workdir "${cwd}" --result)
      ans(exec_result)
      scope_import_map(${exec_result})
      if(return_code)
        json_print(${exec_result})
        message(FATAL_ERROR "failed to fork process.  returned code was ${return_code} message:\n ${stdout}  ")
      endif()

      string(REGEX MATCH "[1-9][0-9]*" pid "${stdout}")
      map_capture_new(pid process_start_info)
      return_ans()
    endif()

    message(FATAL_ERROR "fork not supported on your os")


  endfunction()



  function(fork_script scriptish)
    file_temp_name("{{id}}.cmake")        
    ans(ppath)
    fwrite("${ppath}" "${scriptish}")
    fork("
      {
        command: $CMAKE_COMMAND,
        args:['-P',$ppath]
      }
    ")
    return_ans()
  endfunction()

  function(process_kill process_info)
    map_tryget(${process_info} pid)
    ans(pid)

    if(WIN32)
      win32_taskkill(/PID ${pid} --result)
      ans(res)
      scope_import_map(${res})
      return_ref(res)
    endif()

    message(FATAL_ERROR "cannot kill process - not supported on your os")
  endfunction()

  #splits the specified string into lines 
  function(string_lines input)      
    string_split("${input}" "\n" ";" )
    return_ans(lines)
  endfunction()


  # repeats ${what} and separates it by separator
  function(string_repeat what n)
    set(separator "${ARGN}")
    set(res)
    foreach(i RANGE 1 ${n})
      if(NOT ${i} EQUAL 1)
        set(res "${separator}${res}")
      endif()
      set(res "${res}${what}")
    endforeach()
    return_ref(res)
  endfunction()

  ## returns the key at the specified position
  function(map_key_at map idx)
    map_keys(${map})
    ans(keys)
    list_normalize_index(keys ${idx})
    ans(idx)
    list_get(keys ${idx})
    ans(key)
    return_ref(key)
  endfunction()


  ## returns the value at idx
  function(map_at map idx)
    map_key_at(${map} "${idx}")
    ans(key)
    map_tryget(${map} "${key}")
    return_ans()
  endfunction()

  # parses a table as is output by win32 commands like tasklist
  function(table_parse input)
    string_lines("${input}")
    ans(lines)
    list_pop_front(lines)
    ans(firstline)  
    list_pop_front(lines)    
    ans(secondline)
    list_pop_front(lines)    
    ans(thirdline)

    string(REPLACE "=" "." line_match "${thirdline}")
    string_split("${line_match}" " ")
    ans(parts)
    list(LENGTH parts cols) 
    set(linematch)
    set(first true)
    foreach(part ${parts})
      if(first)
        set(first false)
      else()
        set(linematch "${linematch} ")
      endif()
      set(linematch "${linematch}(${part})")
    endforeach()
 
    set(headers __empty) ## empty is there to buffer so that headers can be index 1 based instead of 0 based
    foreach(idx RANGE 1 ${cols})
      string(REGEX REPLACE "${linematch}" "\\${idx}" header "${secondline}")
      string(STRIP "${header}" header)
      list(APPEND headers ${header})
    endforeach()


  
    set(result)
    foreach(line ${lines})
      map_new()
      ans(l)
      foreach(idx RANGE 1 ${cols})
        string(REGEX REPLACE "${linematch}" "\\${idx}" col "${line}")
        string(STRIP "${col}" col)
        list_get(headers ${idx})
        ans(header)
        map_set(${l} "${header}" "${col}")        
      endforeach()
      list_append(result ${l})
    endforeach()

    return_ref(result)
  endfunction()


  ## if the beginning of the str_name is a delimited string
  ## the undelimited string is returned  and removed from str_name
  function(string_take_delimited str_name )
    set(delimiter ${ARGN})
    if("${delimiter}_" STREQUAL "_")
      set(delimiter \")
    endif()
    set(regex "${delimiter}([^${delimiter}]*)${delimiter}")
    string_take_regex(${str_name} "${regex}")

    ans(match)
    if(NOT match)
      return()
    endif()
    set("${str_name}" "${${str_name}}" PARENT_SCOPE)
    string_slice("${match}" 1 -2)
    ans(res)

    return_ref(res)    
  endfunction()

  function(csv_deserialize csv) 
    set(args ${ARGN})
    list_extract_flag(args --headers)
    ans(first_line_headers)
    string(REPLACE "\r" "" csv "${csv}")

    string_split("${csv}" "\n")
    ans(lines)
    string(STRIP "${lines}" lines)

    set(res)
    set(headers)
    set(first true)
    set(i 0)
    foreach(line ${lines})
      map_new()
      ans(current_line)
      set(current_headers ${headers})
      while(true)
        string_take_delimited(line)
        ans(val)
        if("${line}_" STREQUAL "_")
          break()
        endif()

        string_take(line ",")
        ans(comma)
          
        if(first)
          if(first_line_headers)
            list(APPEND headers "${val}")
          else()
            list(APPEND headers ${i})            
          endif()
          math(EXPR i "${i} + 1")
        else()
          list_pop_front(current_headers)
          ans(current_header)
          map_set(${current_line} "${current_header}" "${val}")
        endif()

      endwhile()
      if(NOT first)
        list(APPEND res ${current_line})
      elseif(NOT  first_line_headers)
        list(APPEND res ${current_line})
      endif()
      if(first)        
        set(first false)
      endif()

    endforeach()
    return_ref(res)
  endfunction()

  function(csv_serialize )
    set(args ${ARGN})


  endfunction()


  function(os)
    if(WIN32)
      return(Windows)
    else()
      return(Unknown)
    endif()


  endfunction()

  ## defines the function called ${function_name} to call an operating system specific function
  ## uses ${CMAKE_SYSTEM_NAME} to look for a function called ${function_name}${CMAKE_SYSTEM_NAME}
  ## if it exists it is wrapped itno ${function_name}
  ## else ${function_name} is defined to throw an error if it is called
  function(wrap_platform_dependent_function function_name)
    os()
    ans(os_name)
    set(specificname "${function_name}_${os_name}")
    if(NOT COMMAND "${specificname}")      
      eval("
      function(${function_name})
        message(FATAL_ERROR \"operation is not supported on ${os_name} - look at document of '${function_name}' and implement a function with a matching interface called '${specificname}' for you own system\")        
      endfunction()      
      ")
    else()
      eval("
        function(${function_name})
          ${function_name}_${os_name}(\${ARGN})
          return_ans()
        endfunction()
      ")
      
    endif()
    return()
  endfunction()

  function(process_info_Windows handlish)
    process_handle("${handlish}")
    ans(handle)
    map_tryget(${handle} pid)
    ans(pid)
    win32_tasklist(/V /FO CSV /FI "PID eq ${pid}")
    ans(csv)
    csv_deserialize("${csv}" --headers)
    ans(res)
    return_ref(res)
  endfunction()

  #function(process_info_Linux handlish)
  #endfunction()

  function(process_info)
    wrap_platform_dependent_function(process_info)
    process_info(${ARGN})
    return_ans()
  endfunction()

  ## returns the runtime unique process handle
  ## 
  function(process_handle handlish)
    map_isvalid("${handlish}")
    ans(ismap)

    if(ismap)
      set(handle ${handlish})
    elseif( "${handlish}" MATCHES "[1-9][0-9]*")
      string(REGEX MATCH "[1-9][0-9]*" handlish "${handlish}")

      map_tryget(__process_handles ${handlish})
      ans(handle)
      if(NOT handle)
        map_new()
        ans(handle)
        map_set(${handle} pid "${handlish}")          
        map_set(${__process_handles} ${handlish} ${handle})
      endif()
    else()
      message(FATAL_ERROR "'${handlish}' is not a valid <process handle>")
    endif()
    return_ref(handle)
  endfunction()


  function(process_list_Windows)
    win32_tasklist(/V /FO CSV)
    ans(res)
    csv_deserialize(${res} --headers)
    ans(res)
    return_ref(res)      
  endfunction()

  ## returns a list of <process info>
  ## process_list():<process info>...
  function(process_list)
    wrap_platform_dependent_function(process_list)
    process_list(${ARGN})
    return_ans()
  endfunction()

  function(process_isrunning_Windows handlish)
    process_handle("${handlish}")
    ans(handle)
    map_tryget(${handle} pid)
    ans(pid)
    win32_tasklist(-FO CSV -FI "PID eq ${pid}" -FI "STATUS eq Running")    
    ans(res)
    if("${res}" MATCHES "PID" AND "${res}" MATCHES "${pid}")
      return(true)
    endif()    
    return(false)
  endfunction()

  ## waits for the process identified by handlish to finish
  ## returns null if the process is invalid
  ## specifiy the --quietly flag to not output anything
  function(process_wait handlish )
    set(args ${ARGN})
    list_extract_flag(args --quitely)
    ans(quietly)
    process_handle("${handlish}")
    ans(handle)
    while(true)
      process_wait_any(${handle})
      ans(isrunning)
      if(NOT isrunning)
          break()
      endif()
    endwhile()
  endfunction()

  ## returns a handle to a process that runs for n seconds
  function(process_timeout n)
    set(script "
      foreach(i RANGE 0 ${n})
        execute_process(COMMAND \${CMAKE_COMMAND} -E sleep 1)
      endforeach()
    ")
    return_ans()
  endfunction()


  function(process_handles)

  endfunction()
  ## waits for all specified process handles to finish
  function(process_wait_all)
    set(args ${ARGN})

    list_extract_flag(args --quietly)
    ans(quietly)   

    list_extract_labelled_value(args --timeout)
    ans(timeout)
    set(timeout_task_handle)
  
    if(timeout)
      process_timeout(${timeout})
      ans(timeout_task_handle)
    endif()

    foreach(handle ${args})

      process_handle(${handle})
      ans(handle)
    endforeach()

    while(true)
      foreach(handle ${timeout_task_handle} ${process_list})
        process_isrunning(${handle})
        ans(isrunning)
        if(NOT isrunning)
          
          if("${timeout_task_handle}_" STREQUAL "${handle}_" )
            return_ref(finished_process_list)
          else()
            list(REMOVE_ITEM process_list ${handle})
            list(APPEND finished_process_list ${handle})
          endif()

        endif()
      endforeach()

    endwhile()
    return_ref(finished_process_list)

  endfunction()


  ## waits until any of the specified handles stops running
  ## returns the handle of that process
  function(process_wait_any)
    set(args ${ARGN})
    list_extract_flag(args --quietly)
    ans(quietly)    
    set(handles)
    foreach(handlish ${args})
      process_handle(${handlish})
      ans(handle)
      list(APPEND handles ${handle})
    endforeach()

    if(NOT quietly)
      echo_append("waiting for process to finish.")  
    endif()

    if(NOT handles)
      return()
    endif()
    while(true)
      set(process_list ${handles})
      set(is_running true)
      foreach(handle ${handles})
        process_isrunning(${handle})

        if(NOT quietly)
          tick()
        endif()
        ans(is_running)
        if(NOT is_running)

          if(NOT quietly)
            echo("")
          endif()
          return_ref(handle)
        endif()        
      endforeach()
    endwhile()

  endfunction()

  # returns true iff the process identified by <handlish> is running
  function(process_isrunning)    
    wrap_platform_dependent_function(process_isrunning)    
    process_isrunning(${ARGN})
    return_ans()
  endfunction()



  set(script "
    foreach(i RANGE 0 10)
      message(\${i})
      execute_process(COMMAND \${CMAKE_COMMAND} -E sleep 1)
    endforeach()
    message(end)
    ")






  #fork_script("${script}")
  #fork_script("${script}")
  fork_script("${script}")
  ans(pi1)
  fork_script("${script}")
  ans(pi2)
  fork_script("${script}")
  ans(pi3)

  #process_list()

  process_wait_any(${pi1} ${pi2} ${pi3})
  ans(res)


  json_print(${res})

  return()

  while(true)

    process_info(${pi})
    ans(res)
    map_tryget(${res} Status)
    ans(running)
    json_print(${res})

    if(NOT "${running}" STREQUAL "Running")
      message("inner done")
      break()
    endif()

    #message("res ${res}")

  endwhile()

  message("done")

  #fork("${CMAKE_COMMAND} -P fork.cmake > currentout.txt")


  #sp(-exec "${CMAKE_COMMAND} -P fork.cmake > currentout.txt" -workdir "${path}" --result)
  #ans(res)


  

  #tasklist()
  #ans(res)
  #message("print ${res}")


  #sleep(5)
  #fread("currentout.txt")
  #ans(res)
  #message("print ${res}")


 # taskkill(/PID ${pid})



endfunction() 

  ## process_wait_all(<handles: <process handle...>> <?"--quietly"> <?"--timeout":<seconds>>)
  ## waits for all specified <handles> to finish
  ## specify --quietly to supress output
  ## if --timeout <n> is specified the function will return all finished processes after n seconds
  function(process_wait_all)
    set(args ${ARGN})

    list_extract_flag(args --quietly)
    ans(quietly)   

    list_extract_labelled_value(args --timeout)
    ans(timeout)
    set(timeout_task_handle)
  

    process_handles(${args})
    ans(processes)


    list(LENGTH processes running_processes)
    set(process_count ${running_processes})
    if(NOT quietly)
      echo_append("waiting for ${running_processes} processes to complete.")
    endif()

    set(timeout_process_handle)
    if(timeout)
      process_timeout(${timeout})
      ans(timeout_process_handle)
      list(APPEND processes ${timeout_process_handle})
    endif()

    while(processes)
      list_pop_front(processes)
      ans(process)
      process_refresh_handle(${process})
      ans(isrunning)
      
      message(FORMAT "{process.pid} isrunning {isrunning} {process.state} ")
      if(NOT quietly)
        tick()
      endif()

      if(NOT isrunning)
        if("${process}_" STREQUAL "_${timeout_process_handle}")
          set(processes)
          if(NOT quietly)
            echo_append(".. timeout")
          endif()
        else()           
          list(APPEND finished ${process})          
          if(NOT quietly)
            list(LENGTH finished finished_count)            
            echo_append("..${finished_count}/${process_count}")
          endif() 
        endif()        
      else()
        ## insert into back
        list(APPEND processes ${process})
      endif()
    endwhile()
    if(NOT quietly)
      echo()
    endif()
    return_ref(finished)
  endfunction()

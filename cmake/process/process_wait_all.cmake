
## `(<handles: <process handle...>>  [--timeout <seconds>] [--idle-callback <callable>] [--task-complete-callback <callable>] )`
##
## waits for all specified <process handles> to finish returns them in the order
## in which they completed
##
## `--timeout <n>`    if value is specified the function will return all 
##                    finished processes after n seconds
##
## `--idle-callback <callable>`   
##                    if value is specified it will be called at least once
##                    and between every query if a task is still running 
##
## `--task-complete-callback <callable>`
##                    if value is specified it will be called whenever a 
##                    task completes.
##
## *Example*
## `process_wait_all(${handle1} ${handle1}  --task-complete-callback "[](handle)message(FORMAT '{handle.pid}')")`
## prints the process id to the console whenver a process finishes
##
function(process_wait_all)
  set(args ${ARGN})

  list_extract_labelled_value(args --idle-callback)
  ans(idle_callback)

  list_extract_labelled_value(args --task-complete-callback)
  ans(task_complete_callback)

  list_extract_labelled_value(args --timeout)
  ans(timeout)
  set(timeout_task_handle)


  process_handles(${args})
  ans(processes)


  list(LENGTH processes running_processes)
  set(process_count ${running_processes})

  set(timeout_process_handle)
  if(timeout)
    process_timeout(${timeout})
    ans(timeout_process_handle)
    list(APPEND processes ${timeout_process_handle})
  endif()

  while(processes)

    if(idle_callback)
      call2("${idle_callback}")
    endif()

    list_pop_front(processes)
    ans(process)
    process_refresh_handle(${process})
    ans(isrunning)
    
    #message(FORMAT "{process.pid} isrunning {isrunning} {process.state} ")

    if(NOT isrunning)
      if("${process}_" STREQUAL "_${timeout_process_handle}")
        set(processes)
      else()          

        list(APPEND finished ${process})          
        if(NOT quietly)
          list(LENGTH finished finished_count)           
          if(task_complete_callback)
            call2("${task_complete_callback}" "${process}") 
          endif()
        endif() 
      endif()        
    else()
      ## insert into back
      list(APPEND processes ${process})
    endif()
  endwhile()

  return_ref(finished)
endfunction()

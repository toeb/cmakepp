
function(test_execute_glob_parallel)
  list_extract_flag(args --no-status)
  ans(no_status)
  set(args ${ARGN})
  cd("${CMAKE_CURRENT_BINARY_DIR}")
  glob("${args}")
  ans(test_files)

  environment_processor_count()
  ans(max)
  set(processes)

  list(LENGTH test_files test_count)
  
  ref_set(test_count ${test_count})
  ref_set(tests_failed)
  ref_set(tests_succeeded)
  ref_set(tests_completed)


  
  function(__tst_status)
    ref_get(tests_failed)
    ans(tests_failed)
    ref_get(tests_succeeded)
    ans(tests_succeeded)
    ref_get(test_count)
    ans(test_count)
    ref_get(tests_completed)
    ans(tests_completed)

    list(LENGTH tests_failed failure_count)
    list(LENGTH tests_succeeded success_count)
    list(LENGTH tests_completed completed_count)

    timer_elapsed(test_time_sum)
    ans(elapsed_time)
    spinner()
    ans(spinner)
    status_line("${completed_count}  / ${test_count}  ok: ${success_count} nok: ${failure_count}  (running ${running_count}) (elapsed time ${elapsed_time} ms) ${spinner}")
  endfunction()

  function(___tst_complete process_handle)
    map_tryget(${process_handle} exit_code)
    ans(error)


    if(error)
      ref_append(tests_failed ${process_handle})
      message(FORMAT "failed: {process_handle.test_file}")
      message(FORMAT "test output: {process_handle.stderr}")
    else()
      ref_append(tests_succeeded ${process_handle})
      message(FORMAT "success: {process_handle.test_file}")

    endif()
    ref_append(tests_completed ${process_handle})

    #print_vars(process_handle.test_file process_handle.exit_code process_handle.state)
   #json_print(${process_handle})
  endfunction()

  set(status_callback)
  if(NOT no_status)
    set(status_callback --idle-callback __tst_status)
  endif()
  timer_start(test_time_sum)

  foreach(test_file ${test_files})
    cmakepp("test_execute" "${test_file}" --async)
    ans(process)


    map_set(${process} test_file ${test_file})

    assign(success = process.on_terminated.add(___tst_complete))

    list(APPEND processes ${process})    
    process_wait_n(-1 ${processes} ${status_callback})
    ans(complete)
    if(complete)
      list(REMOVE_ITEM processes ${complete})
    endif()
  endforeach()
  
  process_wait_n(* ${processes} ${status_callback})
  ans(finished)




endfunction()
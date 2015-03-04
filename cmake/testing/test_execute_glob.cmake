
function(test_create file)

  get_filename_component(test_name "${test}" NAME_WE) 
  # setup a directory for the test
  string_normalize("${test_name}")
  ans(test_dir)
  cmakepp_config(temp_dir)
  ans(temp_dir)
  set(test_dir "${temp_dir}/tests/${test_dir}")
  file(REMOVE_RECURSE "${test_dir}")
  get_filename_component(test_dir "${test_dir}" REALPATH)
  
  map_capture_new(test_dir test_name)
  return_ans()  
endfunction()

function(test_execute_glob_parallel)
  timer_start(parallel)
  cd("${CMAKE_CURRENT_BINARY_DIR}")
  glob("${ARGN}")
  ans(test_files)

  set(max 8)
  set(processes)

  while(processes OR test_files)

    while(true)
      list(LENGTH processes process_count)
      if(NOT "${process_count}" LESS ${max})
        break()
      endif()


      list_pop_front(test_files)
      ans(test_file)

      if(NOT test_file)
        break()
      endif()
      message("starting ${test_file}")
      cmakepp("test_execute" "${test_file}" --async)
      ans(handle)
      map_set(${handle} test_name ${test_file})
      list(APPEND processes ${handle})
    endwhile()


    process_wait_any(${processes} --quietly)
    ans(finished)

    list(REMOVE_ITEM processes ${finished})
    message(FORMAT "finished {finished.test_name}")

  endwhile()

  timer_print_elapsed(parallel)


endfunction()

function(test_execute_glob_separate_process) 


  cd("${CMAKE_CURRENT_BINARY_DIR}")
  glob(${ARGN})
  ans(test_files)
  list(LENGTH test_files len)
  message("found ${len} tests in path for '${ARGN}'")
  set(i 0)
  foreach(test ${test_files})
    test_create("${test}")
    ans(test_obj)
    math(EXPR i "${i} + 1")
    map_tryget("${test_obj}" test_name)
    ans(test_name)
    echo_append("${i} of ${len} '${test_name}'")
    message_indent_push()
    timer_start(test_time)
    cmakepp(test_execute "${test}" --process-handle)
    ans(result)
    timer_print_elapsed(test_time)
    assign(error = result.exit_code)
    if(error)
      echo_append(" [failure]\n")
      map_tryget("${result}" stdout)
      ans(message)
      echo(" ${message}")
      list(APPEND errors ${test})


    else()
      list(APPEND successes ${test})
      echo_append(" [success]\n")
    endif()

    #test_execute("${test}")
    message_indent_pop()
  endforeach()

  if(errors)
    message(FATAL_ERROR "tests failed")
  endif()

endfunction()

function(test_execute_glob)
  timer_start(test_run)
  cd("${CMAKE_CURRENT_BINARY_DIR}")
  glob(${ARGN})
  ans(test_files)
  list(LENGTH test_files len)
  ## sort the test files so that they are always executed in the same order
  list(SORT test_files)
  message("found ${len} tests in path for '${ARGN}'")
  set(i 0)
  foreach(test ${test_files})
    math(EXPR i "${i} + 1")
    message(STATUS "test ${i} of ${len}")
    message_indent_push()
    test_execute("${test}")
    message_indent_pop()
    message(STATUS "done")
  endforeach()

  timer_print_elapsed(test_run)


endfunction()
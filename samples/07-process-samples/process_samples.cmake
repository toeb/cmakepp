function(test)


  set(handles_list)

  set(script "
    foreach(i RANGE 0 10)
      execute_process(COMMAND \${CMAKE_COMMAND} -E sleep 1)
    endforeach()
  ")

  # create some scripts
  foreach(i RANGE 0 5)
    message("starting Task ${i}")
    ## start a process 
    ## since all args are passed on to `execute()`
    ## you specify callbacks for that specific process here
    ## (e.g. --success-callback, error-callback, --state-changed-callback)
    assign(handles_list[] = process_start_script("${script}" --success-callback "[](process_handle) message(FORMAT 'process #${i} succeeded (pid: {process_handle.pid})')")) 
  endforeach()

  ## this function creates a string containing status information
  function(progress_string value maximum ticks)
    math(EXPR multiplier "20/${maximum}")
    math(EXPR value "${value} * ${multiplier}")
    math(EXPR maximum "${maximum} * ${multiplier}")
    math(EXPR rest_count "${maximum} - ${value}")
    string_repeat("=" ${value})
    ans(status)
    string_repeat(" " ${rest_count})
    ans(rest)
    math(EXPR status_ticker "${ticks} % 5")
    string_repeat("." ${status_ticker})
    ans(status_ticker)
    return("[${status}${rest}]${status_ticker}          ")
  endfunction()

  ## this idlecallback displays updating status on the console
  ## it uses the ref 'ticks' to count the numbber of times the idle callback was called
  ref_set(ticks 0)
  function(my_idle_callback)
    ref_get(ticks)
    ans(ticks)
    math(EXPR ticks "${ticks} + 1")
    ref_set(ticks ${ticks})

    progress_string("${finished_count}" "${process_count}" "${ticks}")
    ans(status)
    echo_append("\r${status}")
  endfunction()

  ## process_wait_all has an `--idle-callback` which will be called while polling the process handles_list
  ## 
  process_wait_all(${handles_list} --idle-callback "[]()my_idle_callback({{ARGN}})")







endfunction()
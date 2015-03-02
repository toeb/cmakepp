function(test)

  ## runs three scripts and expects then to stop in a particular order


  process_timeout(5)
  ans(h1)

  process_timeout(10)
  ans(h2)

  process_timeout(1)  
  ans(h3)


set(finished)
  function(spinner)
    map_set(__spinner counter 0)
    function(spinner)
      set(spinner "|" "/" "-")
      list(APPEND spinner "\\")
      map_tryget(__spinner counter)
      ans(counter)
      math(EXPR next "(${counter} + 1) % 4")
      map_set(__spinner counter ${next})
      list(GET spinner ${counter} res )
      return_ref(res)
    endfunction()
  endfunction()
  function(spin)
    spinner()
    ans(current)
    echo_append("\r${ARGN}${current}")
    return()
  endfunction()

  timer_start(t1)
  message(" ")

  set(processes ${h1} ${h2} ${h3})
  while(processes)
    list_pop_front(processes)
    ans(h)
    process_isrunning(${h})
    ans(running)
    timer_elapsed(t1)
    ans(millis)
    spin("waiting ${millis} ms ")
    if( running)
      list(APPEND processes ${h})
    else()
      list(APPEND finished ${h})
    endif()

  endwhile()

  echo("\rwaited ${millis} ms                        ")

  ## assert that the processes finish in order
  assert(EQUALS ${finished} ${h3} ${h1} ${h2})


endfunction()
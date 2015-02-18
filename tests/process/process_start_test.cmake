function(test)

  ## runs three scripts and expects then to stop in a particular order


  process_timeout(8)
  ans(h1)

  process_timeout(16)
  ans(h2)

  process_timeout(1)  
  ans(h3)


set(finished)
  echo_append("waiting")
  set(processes ${h1} ${h2} ${h3})
  while(processes)
    list_pop_front(processes)
    ans(h)
    process_isrunning(${h})
    ans(running)
    tick()
    if( running)
      list(APPEND processes ${h})
    else()
      list(APPEND finished ${h})
    endif()

  endwhile()

  message("done")

  ## assert that the processes finish in order
  assert(EQUALS ${finished} ${h3} ${h1} ${h2})


endfunction()
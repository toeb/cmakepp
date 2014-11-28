## starts a timer identified by id
## 
function(timer_start id)
  map_set_hidden(__timers __prejudice 0)

  # actual implementation of timer_start
  function(timer_start id)
    return_reset()      
    millis()
    ans(millis)
    map_set(__timers ${id} ${millis})
  endfunction()



  ## this is run the first time a timer is started: 
  ## it calculates a prejudice value 
  ## (the time it takes from timer_start to timer_elapsed to run)
  ## this prejudice value is then subtracted everytime elapse is run
  ## thus minimizing the error
  timer_start(initial)  
  timer_elapsed(initial)

  ans(prejudice)
  timer_delete(initial)
  map_set_hidden(__prejudice ${prejudice})

  return_reset()
  timer_start("${id}")
endfunction()
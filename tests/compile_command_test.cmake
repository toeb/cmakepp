function(test)



  timer_start(mytimer)
  timer_start(mysecondtimer)
  timer_elapsed(mysecondtimer)
  ans(res)

  message("${res} ms")




  timers_print_all()


endfunction()
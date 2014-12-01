function(test)



  timer_start(mytimer)
  timer_start(mysecondtimer)
  message("waiting")
  timer_elapsed(mysecondtimer)
  ans(res)

  assert("${res}" GREATER 0)

  timers_print_all()


endfunction()
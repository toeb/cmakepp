function(test)



  process_start(COMMAND "ping.exe" "-t" "heise.de")
  ans(handle)

  process_kill("${handle}")

  process_wait(${handle})



endfunction()
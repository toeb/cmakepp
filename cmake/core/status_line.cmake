function(status_line)
  map_set(global status "${ARGN}")
  echo_append("\r${ARGN}                                                     ")
endfunction()  
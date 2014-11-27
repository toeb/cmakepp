# sleeps for the specified amount of seconds
function(sleep seconds)
  cmake(-E sleep "${seconds}")
  return()
endfunction()
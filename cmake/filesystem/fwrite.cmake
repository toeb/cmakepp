# writs argn to the speicified file creating it if it does not exist and 
# overwriting it if it does.
function(fwrite path)
  path("${path}")
  ans(path)
  file(WRITE "${path}" "${ARGN}")
  return_ref(path)
endfunction()
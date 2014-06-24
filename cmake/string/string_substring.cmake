# wraps the substring command
# optional parameter end 
function(string_substring str start)
  set(end ${ARGN})
  if(NOT end)
    set(end -1)
  endif() 
  string(SUBSTRING "${str}" "${start}" "${end}" res)
  return_ref(res)
endfunction()
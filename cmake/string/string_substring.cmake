# wraps the substring command
# optional parameter end 
function(string_substring str start)
  set(len ${ARGN})
  if(NOT len)
    set(len -1)
  endif() 
  string_normalize_index("${str}" "${start}")
  ans(start)

  string(SUBSTRING "${str}" "${start}" "${len}" res)
  return_ref(res)
endfunction()
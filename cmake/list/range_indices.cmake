## returns the indices specified by range
## 1:3 returns 1 2 3
## 3:-1:1 returns 3 2 1
## see definition of range
function(range_indices range)
  range("${range}")
  ans(range)
  #message("range was ${range}")
  string(REPLACE * "${ARGN}" range "${range}" )
  
  message("range is ${range}")
  set(indices)
  foreach(i ${range})
    list(APPEND indices ${i})
  endforeach()
  return_ref(indices)
endfunction()
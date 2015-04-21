
  
function(promise_from_task)
  promise_new()
  ans(promise)

  task("${ARGN}")
  ans(task)

  if(NOT task)
    return()
  endif()

  map_set("${promise}" task "${task}")
  
  return(${promise})
endfunction()


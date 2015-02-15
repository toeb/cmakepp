
function(event_handler_call event_handler)
  callable_call("${event_handler}" ${ARGN})
  ans(res)
  return_ref(res)
endfunction()

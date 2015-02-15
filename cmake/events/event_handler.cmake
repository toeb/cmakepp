
## creates an <event handler> from the specified callable
function(event_handler callable)
  callable("${callable}")
  ans(event_handler)
  return_ref(event_handler)
endfunction()

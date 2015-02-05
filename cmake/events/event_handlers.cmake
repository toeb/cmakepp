## event_handlers
##
## returns the handlers registered for event
function(event_handlers event_name)
  event_get("${event_name}")
  ans(event)

  if(NOT event)
    return()
  endif()

  map_tryget(${event} handlers)
  return_ans()

endfunction()
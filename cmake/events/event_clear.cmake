## removes all handlers from the specified event
function(event_clear event_name)
  event_get("${event_name}")
  ans(event)

  event_handlers("${event_name}")
  ans(handlers)

  foreach(handler ${handlers})
    event_removehandler("${event_name}" "${handler}")
  endforeach()  

  return()
endfunction()


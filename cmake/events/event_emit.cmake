# emits the specified event 
# calls all registered event handlers for event '<name>'
function(event_emit name)
  event_get("${name}")
  ans(event)
  set(success)
  if( event)
    
    map_tryget(${event} handlers)
    ans(handlers)
    foreach(handler ${handlers})
      rcall(success = "${handler}"(${ARGN}))
    endforeach()

  endif()
  if(NOT "${name}" STREQUAL "on_event")
    event_emit(on_event "${name}" "${ARGN}")

  endif()

  return_ref(success)
endfunction() 

# emits the specified event 
# calls all registered event handlers for event '<name>'
function(event_emit name)
  event_get("${name}")
  ans(event)
  set(success)

  if(event)    
    set(previous_handlers)
    # loop solang as new event handlers are appearing
    while(true)
      map_tryget(${event} handlers)
      ans(handlers)
      list(REMOVE_ITEM handlers ${previous_handlers} "")
      list(APPEND previous_handlers ${handlers})

      list_length(handlers)
      ans(length)
      if(NOT "${length}" GREATER 0) 
        break()
      endif()

      foreach(handler ${handlers})
        rcall(success = "${handler}"(${ARGN}))
      endforeach()

    endwhile()
  endif()

  if(NOT "${name}" STREQUAL "on_event")
    event_emit(on_event "${name}" "${ARGN}")
  endif()

  return_ref(success)
endfunction() 

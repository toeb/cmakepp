# emits the specified event 
# calls all registered event handlers for event '<name>'
function(event_emit event_name)
  event_get("${event_name}")
  ans(event)
  set(result)

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
        list(APPEND result "${success}")
      endforeach()

    endwhile()
  endif()

  if(NOT "${event_name}" STREQUAL "on_event")
    event_emit(on_event "${event_name}" "${ARGN}")
    return_ans()
  endif()

  return_ref(result)
endfunction() 

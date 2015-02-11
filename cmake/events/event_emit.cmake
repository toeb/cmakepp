## event_emit
##
## emits the specified event 
## calls all registered event handlers for event '<name>'
## if event handlers are added during an event they will be called as well
## if a event calls event_cancel() 
## all further event handlers are disregarded
function(event_emit event_name)
  event_get("${event_name}")
  ans(event)
  set(result)

  if(event)    
    set(previous_handlers)
    # loop aslong as new event handlers are appearing
    # 
    ref_new()
    ans(__current_event_cancel)
    ref_set(${__current_event_cancel} false)
    while(true)
      ## 
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
        ## check if cancel is requested
        ref_get(${__current_event_cancel})
        ans(break)
        if(break)
          return_ref(result)
        endif()
      endforeach()
    endwhile()
  endif()

  if(NOT "${event_name}" STREQUAL "on_event")
    event_emit(on_event "${event_name}" "${ARGN}")
    return_ans()
  endif()

  return_ref(result)
endfunction() 


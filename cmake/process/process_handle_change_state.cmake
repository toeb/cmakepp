
function(process_handle_change_state process_handle new_state)
  map_tryget("${process_handle}" state)
  ans(old_state)
  if("${old_state}" STREQUAL "${new_state}")
    return(false)
  endif()

  map_tryget(${process_handle} on_state_changed)
  ans(event)

  event_emit(${event} ${process_handle})

  map_set(${process_handle} state "${new_state}")
  return(true)
endfunction()
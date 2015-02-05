# removes the specified handler from the event idenfied by name
function(event_removehandler name handler)
  event_get("${name}")
  ans(event)
  if(NOT event)
    return(false)
  endif()

  map_remove_item("${event}" handlers "${handler}")
  ans(success)
  
  return_truth("${success}")
  
endfunction()
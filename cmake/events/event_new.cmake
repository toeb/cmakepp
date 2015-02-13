# creates an registers a new event
function(event_new name)
  events()
  ans(events)

  map_new()
  ans(event)

  map_set(${event} name "${name}")
  
  map_set(${events} "${name}" ${event})
  
  return(${event})  
endfunction()
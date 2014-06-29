# returns the event identified by name
function(event_get name)
  events()
  ans(events)
  map_tryget(${events} "${name}")
  return_ans()
endfunction()

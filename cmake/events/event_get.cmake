## `(<event-id>)-><event>`
##  
## returns the `<event>` identified by `<event-id>` 
## if the event does not exist `<null>` is returned.
function(event_get event_id)
  events()
  ans(events)
  map_tryget(${events} "${event_id}")
  return_ans()
endfunction()

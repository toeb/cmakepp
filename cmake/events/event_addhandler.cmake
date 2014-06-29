# adds an event handler to the event specified by name
function(event_addhandler name handler)
  event("${name}")
  ans(event)
  
  map_tryget("${event}" handlers)
  ans(handlers)

  set(handlers ${handlers} "${handler}")
  map_append("${event}" handlers "${handler}")
  list_unique(handlers)
  ans(handlers)
  map_set("${event}" handlers "${handlers}")

  return()
endfunction()
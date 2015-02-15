## event_addhandler()
##
## adds an event handler to the event specified by name
##
function(event_addhandler event handler)
  event("${event}")
  ans(event)

  event_handler("${handler}")
  ans(handler)

  ## then only append function 
  map_append_unique("${event}" handlers "${handler}")
 
  return(${handler})  
endfunction()


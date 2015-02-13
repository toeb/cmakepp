## event_addhandler()
##
## adds an event handler to the event specified by name
##
function(event_addhandler name handler)
  event("${name}")
  ans(event)


  function_import("${handler}")
  ans(handler)



  ## todo - maybe escape handler string semicolon?
  ## todo import handler function and create  a mapping from handler->fuction
  ## then only append function 
  map_append_unique("${event}" handlers "${handler}")
 
  return()  
endfunction()



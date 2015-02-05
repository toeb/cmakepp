## event_cancel()-><null>
##
## only for inside event handlers 
## causes event_emit not to continue with event 
function(event_cancel)
  ref_set(${__current_event_cancel} true)
  return()
endfunction()
## `()-><null>`
##
## only usable inside event handlers. cancels the current event and returns
## after this handler.
function(event_cancel)
  ref_set(${__current_event_cancel} true)
  return()
endfunction()
# returns an exisitng event or a new event
function(event name)
  event_get("${name}")
  ans(event)
  if(NOT event)
    event_new("${name}")
    ans(event)
  endif()
  
  return_ref(event)
endfunction()
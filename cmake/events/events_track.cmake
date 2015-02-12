## sts up a function which listens only to the specified events
function(events_track)
  function_new()
  ans(function_name)

  map_new()
  ans(map)

  eval("
    function(${function_name})
      map_new()
      ans(event_args)
      map_set(\${event_args} name \${event_name})
      map_set(\${event_args} args \${ARGN})
      map_set(\${event_args} event \${event})
      map_append(${map} \${event_name} \${event_args})
      map_append(${map} on_event \${event_args})
      return(\${event_args})
    endfunction()
  ")

  foreach(event ${ARGN})
    event_addhandler(${event} ${function_name})
  endforeach()

  return(${map})
endfunction()
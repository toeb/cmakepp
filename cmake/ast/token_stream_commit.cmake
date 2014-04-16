
  function(token_stream_commit stream)
    map_get(${stream} stack stack)
    #map_get(${stream} current current)
    stack_pop(${stack})
    #message("committed")
  endfunction()
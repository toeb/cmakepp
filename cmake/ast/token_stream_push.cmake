
  function(token_stream_push stream)
    map_get(${stream} stack stack)
    map_get(${stream} current current)
    stack_push(${stack} ${current})
   # message("pushed")
  endfunction()
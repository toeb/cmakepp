
  function(token_stream_pop stream)
    map_get(${stream} stack stack)
    stack_pop(${stack})
    ans(current)
    map_set(${stream} current ${current})
  #  message(FORMAT "popped to {current.data}")
  endfunction()
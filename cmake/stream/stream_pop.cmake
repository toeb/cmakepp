

  function(stream_pop stream)
    pop_front("stream_stack_${stream}" data)
    ref_set(${stream} "${data}")  
  endfunction()
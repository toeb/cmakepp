


  function(stream_push stream)
    ref_get(${stream} data)
    push_front("stream_stack_${stream}" "${data}")
  endfunction()
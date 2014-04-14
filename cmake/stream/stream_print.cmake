
  function(stream_print stream)
    ref_get(${stream} data)
    message("stream: '${data}'")
  endfunction()
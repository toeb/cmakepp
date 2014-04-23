
  function(stream_commit stream)
    ref_get(${stream} data)
    stream_pop(${stream})
    ref_set(${stream} "${data}")
  endfunction()
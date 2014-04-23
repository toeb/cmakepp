
  function(stream_commit stream)
    ref_get(${stream} )
    ans(data)
    stream_pop(${stream})
    ref_set(${stream} "${data}")
  endfunction()
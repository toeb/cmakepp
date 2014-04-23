
  function(stream_trim stream)
    stream_take_regex(${stream} "[\r\n\t ]+")
    return_ans()
  endfunction()
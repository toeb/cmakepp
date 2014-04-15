
  function(queue_push queue)
    string_encode_list("${ARGN}")
    ans(encoded)
    ref_append(${queue} "${encoded}")
  endfunction()
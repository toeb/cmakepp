
  function(queue_peek queue)
    ref_get(${queue} lst)
    list_peek_front(lst res)
    string_decode_list("${res}")
    ans(decoded)
    return_ref(decoded)
  endfunction()
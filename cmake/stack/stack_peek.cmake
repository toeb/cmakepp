
  function(stack_peek stack)
    ref_get(${stack} lst)
    list_peek_back(decoded lst)
    string_decode_list("${decoded}")
    ans(decoded)
    return_ref(decoded)
  endfunction()
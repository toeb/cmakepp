
  function(stack_peek stack)
    ref_get(${stack} lst)
    list_peek_back(lst res)
    #string_decode_list("${res}")
   # ans(decoded)
    return_ref(decoded)
  endfunction()
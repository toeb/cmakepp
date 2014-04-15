
  function(stack_push stack)
    string_encode_list("${ARGN}")
    ans(encoded)
   # message("pushed ${encoded}")
    ref_append(${stack} "${encoded}")
  endfunction()
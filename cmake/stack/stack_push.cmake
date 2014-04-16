
  function(stack_push stack)
  set(encoded "${ARGN}")
    #string_encode_list("${encoded}")
   # ans(encoded)
   # message("pushed ${encoded}")
    ref_append(${stack} "${encoded}")
  endfunction()
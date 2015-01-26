
  function(ref_push_front ref)
    ref_get(${ref})
    ans(value)
    list_push_front(value ${ARGN})
    ans(res)
    ref_set(${ref} ${value})
    return_ref(res)
  endfunction()
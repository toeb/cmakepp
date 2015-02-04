
  function(ref_peek_back ref)
    ref_get(${ref})
    ans(value)
    list_peek_back(value ${ARGN})
    ans(res)
    return_ref(res)
  endfunction()
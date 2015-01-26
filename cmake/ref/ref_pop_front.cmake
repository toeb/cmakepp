
  function(ref_pop_front ref)
    ref_get(${ref})
    ans(value)
    list_pop_front(value)
    ans(res)
    ref_set(${ref} ${value})
    return_ref(res)
  endfunction()
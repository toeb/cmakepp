
  function(ref_pop_back ref)
    ref_get(${ref})
    ans(value)
    list_pop_back(value)
    ans(res)
    ref_set(${ref} ${value})
    return_ref(res)
  endfunction()
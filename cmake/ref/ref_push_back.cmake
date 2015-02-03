
  function(ref_push_back ref)
    ref_get(${ref})
    ans(value)
    list_push_back(value "${ARGN}")
    ans(res)
    ref_set(${ref} ${value})
    return_ref(res)
  endfunction()

  ## returns the length of the specified property
  function(map_property_length map prop)
    map_tryget("${map}" "${prop}")
    ans(val)
    list(LENGTH val len)
    return_ref(len)
  endfunction()
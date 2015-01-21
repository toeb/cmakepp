

  function(listing_combine)
    listing()
    ans(lst)
    foreach(listing ${ARGN})
      ref_get(${listing})
      ans(current)
      ref_append("${lst}" "${current}")
    endforeach()
    return(${lst})
  endfunction()
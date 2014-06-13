

  function(list_max lst comparer)
    list_fold(${lst} "${comparer}")
    ans(res)
    return(${res})
  endfunction()

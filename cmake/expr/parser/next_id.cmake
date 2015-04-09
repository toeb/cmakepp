

  function(next_id)
    map_tryget("${context}" current_id)
    math(EXPR __ans "${__ans} + 1")
    map_set(${context} current_id ${__ans})
    return("_${__ans}")
  endfunction()

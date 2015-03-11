
  ## compares two rated package sources and returns a number
  ## pointing to the lower side
  function(rated_package_source_compare lhs rhs)
      map_tryget(${rhs} rating)
      ans(rhs)
      map_tryget(${lhs} rating)
      ans(lhs)
      math(EXPR result "${lhs} - ${rhs}")
      return_ref(result)
  endfunction()
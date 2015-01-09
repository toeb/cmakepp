
  ## checks if all fields specified in rhs are equal to the values in lhs
  ## recursively checks submaps
  function(map_match lhs rhs)
    if("${lhs}_" STREQUAL "${rhs}_")
      return(true)
    endif()

    map_isvalid("${rhs}")
    ans(rhs_ismap)

    map_isvalid("${lhs}")
    ans(lhs_ismap)

  
    if(NOT lhs_ismap OR NOT rhs_ismap)
      return(false)
    endif()


    map_iterator(${rhs})
    ans(it)

    while(true)
      map_iterator_break(it)

      map_tryget("${lhs}" "${it.key}")
      ans(lhs_value)

      map_matches("${lhs_value}" "${it.value}")
      ans(values_match)

      if(NOT values_match)
        return(false)
      endif()

    endwhile()

    return(true)


  endfunction()
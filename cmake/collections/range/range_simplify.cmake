
  ## tries to simplify the specified range for the given length
  function(range_simplify length)
    set(args ${ARGN})

    list_pop_front(args)
    ans(current_range)

    range_indices("${length}" "${current_range}")
    ans(indices)

    while(true)
      #print_vars(indices)
      list(LENGTH args indices_length)
      if(${indices_length} EQUAL 0)
        break()
      endif()
      list_pop_front(args)
      ans(current_range)
      #print_vars(current_range)
      list_range_get(indices "${current_range}")
      ans(indices)
    endwhile()


    #print_vars(indices)
    range_from_indices(${indices})
    return_ans()
  endfunction()
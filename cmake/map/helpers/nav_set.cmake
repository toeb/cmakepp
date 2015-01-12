
  function(nav_set base_value expression new_value)
    nav_analyze("${base_value}" expression_rest "${expression}")
    ans(expressions_left)
    
    nav_analyze("${base_value}" last_property "${expression}")
    ans(prop)
    nav_analyze("${base_value}" last_value_ranges "${expression}")
    ans(range)
    nav_analyze("${base_value}" last_property_ref "${expression}")
    ans(ref)

    if(expressions_left)
      return()
    endif()

    
    if(NOT expressions_left AND NOT ref AND NOT range)
      return_ref(new_value)
    endif()

    if(NOT ref AND range)
      #print_vars(base_value range new_value)
      list_range_partial_write(base_value "${range}" "${new_value}")
      return_ref(base_value)
    endif()

    if(ref AND prop)
      if(range)
        map_tryget("${ref}" "${prop}")
        ans(val)
        #list_range_set(val "${range}" "${new_value}")
        list_range_partial_write(val "${range}" ${new_value})
        set(new_value "${val}")
      endif()
      map_set("${ref}" "${prop}" "${new_value}")
      return_ref(base_value)
    endif()


    message(FATAL_ERROR "not implemented")

    return_ref(base_value)
  endfunction()

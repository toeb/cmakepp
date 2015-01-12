
  function(nav_write base_value expression)
    navigation_expression_parse("${expression}")
    ans(expression)

    nav_analyze("${base_value}" expression_rest "${expression}")
    ans(expression_rest)

    nav_analyze("${base_value}" current_path "${expression}")
    ans(current_path)

    nav_analyze("${base_value}" last_property "${expression}")
    ans(prop)
    nav_analyze("${base_value}" last_value_ranges "${expression}")
    ans(range)
    nav_analyze("${base_value}" last_property_ref "${expression}")
    ans(ref)
    nav_analyze("${base_value}" current_value "${expression}")
    ans(current_value)

    list(LENGTH current_path current_path_length)
    list_range_remove(expression "[0:${current_path_length})")

#    if(NOT ref AND prop)
 #     set(expression_rest ${prop} ${expression_rest})
  #  endif()

#  print_vars(expression base_value current_path ref prop current_value)

    if(ref AND prop)
      list_peek_front(expression)
      ans(expr)
      if(NOT "${expr}" MATCHES "\\[.*\\]")  
        list_pop_front(expression)
        ans(prop)
      endif()

    endif()
   # print_vars(expression)
    nav_create_path("${expression}" ${ARGN})
    ans(new_value)


    if(NOT ref AND NOT range)
      return_ref(new_value)
    endif()

    if(NOT ref AND range)
     # print_vars(base_value range new_value)
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
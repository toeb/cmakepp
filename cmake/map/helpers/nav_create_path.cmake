

  function(nav_create_path expression)
    navigation_expression_parse("${expression}")
    ans(expression)


    set(current_value ${ARGN})
      

    while(true)
      list(LENGTH expression len)
      if(NOT len)
        break()
      endif()      
      list_pop_back(expression)
      ans(current)
      analyze_expression(current current)

      if(current_is_range)
        ## todo may allow more like "[:] [n] etc using range_parse"
        if(NOT "${current_range}" STREQUAL "[]")
          message(FATAL_ERROR "invalid range '${current_range}'")
        endif()
      elseif(current_is_property)
        map_new()
        ans(map)
        map_set("${map}" "${current_property}" "${current_value}")
        set(current_value "${map}")
      endif()

    endwhile()  
    #json_print(${current_value})
    return_ref(current_value)
  endfunction()
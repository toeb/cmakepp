
  function(analyze_value value_ref result_ref)
      set(is_ref false)
      set(is_null false)
      set(is_single false)
      set(is_list false)
      set(is_primitive false)
      list(LENGTH ${value_ref} value_length)
      if(${value_length} EQUAL 0)
        set(is_null true)
      elseif(${value_length} EQUAL 1)
        set(is_single true)
        map_isvalid("${${value_ref}}")
        ans(is_ref)
        if(NOT is_ref)
          set(is_primitive true)
        endif()
      else()
        set(is_list true)
      endif()

      set(${result_ref}_is_ref ${is_ref} PARENT_SCOPE)
      set(${result_ref}_is_null ${is_null} PARENT_SCOPE)
      set(${result_ref}_is_single ${is_single} PARENT_SCOPE)
      set(${result_ref}_is_list ${is_list} PARENT_SCOPE)
      set(${result_ref}_is_primitive ${is_primitive} PARENT_SCOPE)
      set(${result_ref}_length ${value_length} PARENT_SCOPE) 

  endfunction()


  function(analyze_expression expresion_ref result_ref)

    set(property)
    set(range)
    if("${${expresion_ref}}" MATCHES "^\\[.*\\]$")
      set(is_range true)
      set(is_property false)
      set(range ${${expresion_ref}})
    else()
    
      set(is_range false)
      set(is_property true)
      set(property ${${expresion_ref}})

    endif()
    set(${result_ref}_is_range ${is_range} PARENT_SCOPE)
    set(${result_ref}_is_property ${is_property} PARENT_SCOPE)
    set(${result_ref}_range ${range} PARENT_SCOPE)
    set(${result_ref}_property ${property} PARENT_SCOPE)

  endfunction()

  ## analyzes the nav expression
  function(nav_analyze base_value what)

    navigation_expression_parse(${ARGN})
    ans(expression_input)
    #message("expression_input '${expression_input}'")

    set(expression_rest ${expression_input})    
    set(current_value ${base_value})
    set(last_ref)
    set(last_property_ref)
    set(last_property)
    set(last_range)
    set(last_existing_property)
    set(last_existing_property_ref)
    set(last_value_ranges)

    set(current_path)

    #print_vars(current_value expression_rest)

    while(true)
      ## check wether current_value is a list or a ref or null
      ## break loop if null 
      analyze_value(current_value current)
     
    
      list(LENGTH expression_rest expressions_left)

      # print_vars(
      #   current_expression 
      #   expressions_left
      #   expression_rest
      #   current_value 
      #   current_is_range 
      #   current_is_property 
      #   current_is_null 
      #   current_is_ref 
      #   current_is_primitive
      #   current_is_single
      #   current_is_list
      # )

      if(NOT expressions_left)
        #message("done")
        #message(POP)
        break()
      endif()

      ## check if current expression is a range or a property
      ## remove it from list of expressions
      ## and store either in current_property or current_range
      list_pop_front(expression_rest)
      ans(current_expression)
      analyze_expression(current_expression current)

      #message(PUSH)

      
      if(current_is_ref)
        set(last_ref ${current_value})
      endif()


      if(current_is_property)
        set(last_property ${current_property})
      elseif(current_is_range)
        set(last_range ${current_property})
      endif()


      set(previous_value ${current_value})
     # print_vars(current_value current_expression current_is_range)
      if(current_is_range)  
        #list_range_get(current_value "${current_expression}")
        list_range_try_get(current_value "${current_expression}")
        
        ans(current_value)
        list(APPEND last_value_ranges "${current_expression}")

        #if(NOT "${current_value}_" STREQUAL "_")
        #endif()
        #message("getting range '${current_expression}' from '${previous_value}' => '${current_value}'")
      elseif(current_is_property)
        if(current_is_ref)
          map_tryget("${current_value}" "${current_expression}")
          ans(current_value)
          set(last_property_ref "${last_ref}")
          if(NOT "${current_value}_" STREQUAL "_")
            set(last_existing_property "${current_property}")
            set(last_existing_property_ref "${last_ref}")
            set(last_value_ranges)
          endif()
          #message("getting property '${current_expression}' from '${previous_value}' => '${current_value}'")


        elseif(current_is_list)
          set(current_value)
          #message("trying to get property '${current_expression}' of list '${previous_value}'")
          break()
        elseif(current_is_primitive)
          set(current_value)

          #message("trying to get property '${current_expression}' of primitive '${previous_value}'")
          break()
        endif()

      endif()

      #print_vars(current_expression)
      if(current_value)
        list(APPEND current_path "${current_expression}")
      endif()

      #message(POP)


    endwhile()



    #message(" \n")
    return_ref("${what}")
  endfunction()
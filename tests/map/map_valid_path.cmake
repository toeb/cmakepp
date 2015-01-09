function(test)

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


  function(map_path_of_last_ref base_value what)

    navigation_expression_parse(${ARGN})
    ans(expression_input)
    message("expression_input '${expression_input}'")

    set(expression_rest ${expression_input})    
    set(current_value ${base_value})
    set(last_ref)
    set(last_property)
    set(last_range)
    set(last_existing_property)
    set(last_existing_property_ref)
    set(last_existing_property_ranges)


    set(path)


    while(true)
      ## check wether current_value is a list or a ref or null
      ## break loop if null 
      analyze_value(current_value current)
     
    
      list(LENGTH expression_rest expressions_left)

      print_vars(
        current_expression 
        expressions_left
        expressions_rest
        current_value 
        current_is_range 
        current_is_property 
        current_is_null 
        current_is_ref 
        current_is_primitive
        current_is_single
        current_is_list
      )

      if(NOT expressions_left)
        message("done")
        break()
      endif()

      ## check if current expression is a range or a property
      ## remove it from list of expressions
      ## and store either in current_property or current_range
      list_pop_front(expression_rest)
      ans(current_expression)
      analyze_expression(current_expression current)

      message(PUSH)


      if(current_is_ref)
        set(last_ref ${current_value})
      endif()

      if(current_is_property)
        set(last_property ${current_property})
      elseif(current_is_range)
        set(last_range ${current_property})
      endif()


      set(previous_value ${current_value})
      if(current_is_range)  
        list_range_get(current_value "${current_expression}")
        ans(current_value)
        if(NOT "${current_value}_" STREQUAL "_")
          list(APPEND last_existing_property_ranges "${current_expression}")
        endif()
        message("getting range '${current_expression}' from '${previous_value}' => '${current_value}'")
      elseif(current_is_property)
        if(current_is_ref)
          map_tryget("${current_value}" "${current_expression}")
          ans(current_value)
          if(NOT "${current_value}_" STREQUAL "_")
            set(last_existing_property "${current_property}")
            set(last_existing_property_ref "${last_ref}")
            set(last_existing_property_ranges)
          endif()
          message("getting property '${current_expression}' from '${previous_value}' => '${current_value}'")


        elseif(current_is_list)
          set(current_value)
          message("trying to get property '${current_expression}' of list '${previous_value}'")
          break()
        elseif(current_is_primitive)
          set(current_value)
          message("trying to get property '${current_expression}' of primitive '${previous_value}'")
          break()
        endif()

      endif()

      list(APPEND path "${current_expression}")



      message(POP)


    endwhile()



    message(" \n")
    return_ref("${what}")
  endfunction()


  function(test_func_obj input what)
    print_vars(input what)
    obj("${input}")
    ans(map)
    if(NOT map)
      set(map ${input})
    endif()
    map_path_of_last_ref("${map}" "${what}" ${ARGN})
    return_ans()
  endfunction()

  define_test_function(test_uut test_func_obj input what)


  # current value
  test_uut("123" "123" current_value)
  test_uut("123" "abc;123;456" current_value "[1]")
  test_uut("456;123" "abc;123;456" current_value "[2,1]")
  
  test_uut("123" "{a:123}" current_value "a")
  test_uut("123" "{a:{b:123}}" current_value "a.b")
  test_uut("" "{a:123}" current_value "b")
  test_uut("" "{a:123}" current_value "a.b")


  test_uut("123" "{a:123}" current_value "a[0]")
  test_uut("123" "{a:123}" current_value "a[:]")
  test_uut("123;345" "{a:[123,345]}" current_value "a[:]")

  test_uut("123" "{a:[234,{a:123},456]}" current_value "a.[1].a")
  test_uut("" "{a:[234,{a:123},456]}" current_value "a.[2].a")
  test_uut("123" "{a:[234,{a:[567,{a:123},789]},456]}" current_value "a[1].a[1].a")

  test_uut("123" "abc;456;234;poi;123;867" current_value "[:][$:2:-1][1]") 


  # last property
  
  test_uut("" "123" last_property)
  test_uut("a" "{a:123}" last_property a)
  test_uut("" "{a:123}" last_property [0])


  # last_existing_property
  test_uut("" "123" last_existing_property a)
  test_uut("a" "{a:123}" last_existing_property a)
  test_uut("a" "{a:123}" last_existing_property "a.b")
  test_uut("b" "{a:{b:123}}" last_existing_property "a.b")
  test_uut("b" "{a:[456,{b:123},678]}" last_existing_property "a[1].b")

  # last_existing_ref
  test_uut("{b:123}" "{a:{b:123}}" last_existing_property_ref "a.b")
  test_uut("{b:123}" "{a:[456,{b:123},678]}" last_existing_property_ref  "a[1].b")


  # last_existing_property_ranges
  test_uut("[1]" "{a:{b:[345,123]}}" last_existing_property_ranges "a.b[1]")
  test_uut("[1];[0]" "{a:{b:[345,123]}}" last_existing_property_ranges "a.b[1][0]")
  test_uut("[1:0:-1];[1];[0]" "123;456" last_existing_property_ranges "[1:0:-1][1][0]")


  # current_length
  test_uut(5 "1;2;3;4;5" current_length)
  test_uut(4 "{a:[4,3,2,1]}" current_length a)

  return()
  test_uut("{a:{b:{c:123}}}" "a.b.c" last_ref_path a b)
  test_uut("{a:{b:{c:{d:123}}}}" "a.b.c" last_ref_path a b)
  test_uut("{a:{b:{c:{d:123}}}}" "a.b.d" last_ref_path a b)

  return()
  test_uut("{}" "[0]" "[0]")
  test_uut("{}" "[0][0]" "[0]" "[0]")
  test_uut("{}" "[:]")
  test_uut("{a:{b:{c:[3,{d:{e:123}},5]}}}" "[0][0][0][0].a.b.c[1].d.e")
  test_uut("{}" "a")
  test_uut("{}" "[0]" "[0]")
  test_uut("{a:{b:123}}" "a[0]" a [0])
  test_uut("{}" "a.b.c")
  test_uut("{a:[1,3,{c:123},4]}" "a[2].c" a [2])
  test_uut("{}" "")
  test_uut("{a:{b:{c:123}}}" "a.b.c" a b)
  test_uut("{a:{b:{c:123}}}" "a.b.d" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "a.b.c" a b c)
  test_uut("{a:{b:{c:{d:123}}}}" "a.b.d" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "a.b.d.e" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "a.b.d[3]" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "a.b.d[3]" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "a.b.d.e[3]" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "a.f.d" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "b" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "b[1][2][3]" a b)
  test_uut("{a:{b:{c:{d:123}}}}" "b[1].c" a b)


endfunction()
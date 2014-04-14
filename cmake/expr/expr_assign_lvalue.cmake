#‡†
  function(expr_assign_lvalue lvalue rvalue scope)
    message("assigning ${lvalue} = ${rvalue}")
   # string_char_at(trash 0 "${lvalue}" )
   # ans(first_char)
   # if("${first_char}" STREQUAL "*")
   #   #message("dereffing")
   #   string(SUBSTRING "${lvalue}" 1 -1 ref_expr)
   #   expr("${ref_expr}")
   #   ans(ref)
   #   if(NOT ref)
   #     message(FATAL_ERROR "${ref_expr} does not evaluate to a ref")
   #   endif()
   #  # message("ref is ${ref}")
   #   ref_isvalid(${ref} trash)
   #   ans(isref)
   #   if(isref)
   #   #message("assigning ref ${rvalue}")
   #     ref_set(${ref} "${rvalue}")
   #   endif()
   #   return()
   # endif()
    set(regex_identifier "[a-zA-Z0-9-_]+")

    string(REPLACE ";" "†" lvalue "${lvalue}")
    

    if(NOT "${first_char}"  STREQUAL "[")
      set(lvalue ".${lvalue}")
    endif()


    string_nested_split("${lvalue}" "[" "]")
    ans(splits)
    message("splits ${splits}")
    set(lvalue)


    foreach(split ${splits})
      if("${split}" MATCHES "^\\[.+\\]$")
        string_slice("${split}" 1 -2)
        ans(inner_split)
        expr("${inner_split}")
        ans(split)
        set(split "[${split}]")
      endif()
      list(APPEND lvalue "${split}")
    endforeach()
    string(REPLACE ";" "" lvalue "${lvalue}")
    string(REPLACE "†" ";" lvalue "${lvalue}")
    string(REPLACE "." ";" lvalue "${lvalue}")
    string(REPLACE "[" ";" lvalue "${lvalue}")
    string(REPLACE "]" "" lvalue "${lvalue}") 


   # string(REGEX REPLACE "")
    message("lvalue transformed: ${lvalue}")

    set(current_scope ${scope})
    set(last_scope)
    set(path ${lvalue})
    set(current_index)
    set(last_index)
    while(true)
      set(next_scope)
      set(last_index ${current_index})
      list_pop_front(current_index path )  
      list_empty(path)
      ans(is_done)

      
      map_isvalid(${current_scope} trash)
      ans(is_map)

      ref_isvalid(${current_scope} trash)
      ans(is_ref)
      

      expr_integer_isvalid("${current_index}")
      ans(is_int_index)

      message("current index: ${current_index}")
      message("rest:${path}")
      message("int index:${is_int_index}")
      message("is_done ${is_done}")
      message("is_map ${is_map}")
      message("is_ref ${is_ref}\n")


      
      if(is_map)
        if(is_int_index)
          map_keys(${current_scope} keys)
          list_get(keys "${current_index}")
          ans(current_index)
        endif()
        if(NOT current_index)
          # invalid key
          message(FATAL_ERROR "invalid key '${current_index}'")
          return()
        endif()
        # index now is a string index in all cases

        if(is_done)
          map_set(${current_scope} "${current_index}" "${rvalue}")
          return_ref(rvalue)
          # finished setting value
        endif()
        # navigate
        map_tryget(${current_scope} next_scope "${current_index}")
        if(NOT next_scope)
          map_create(next_scope)
          map_set(${current_scope} "${current_index}" ${next_scope})
        endif()

        # next_scope exists

      elseif(is_ref)
        if(is_done)
          ref_set(${current_scope} ${rvalue})
          return_ref(rvalue)
          # finished setting value
        endif()

        if(NOT is_int_index)
          message(FATAL_ERROR "can only set string indices on maps")
          return()
        endif()

        message(FATAL_ERROR "not iplemented for ref currently") 


      else()
        message("just a var")
        if(is_done)
          if(NOT is_int_index)
              message(FATAL_ERROR "cannot set string index for a cmake list")
          endif()
          map_get(${last_scope} last_value ${last_index})
          list_set(last_value ${current_index} "${rvalue}")
          ans(success)
          if(NOT success)
            message(FATAL_ERROR "cannot set ${current_index} because it is invalid for list")
          endif()
          map_set(${last_scope} ${last_index} "${last_value}")
        endif()
      endif()


      set(last_scope ${current_scope})
      set(current_scope ${next_scope})

      if(is_done)
        break()
      endif()
    endwhile()

    return()
  endfunction()
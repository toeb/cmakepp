  # evaluates a oo-cmake expression
  function(expr )
    return_reset()

    set(expressions ${ARGN})

    list(LENGTH expressions len)
    if(${len} EQUAL 0)
     return()
    endif()


    # multiple expressions
    if(${len} GREATER 1)
      set(result)
      foreach(part ${expressions})
        expr("${part}")
        ans(res)
        list(APPEND result "${res}")
      endforeach()
      return_ref(result)
    endif()

    set(expr "${expressions}")

   # string_nested_split("${expr}" { })
    #ans(parts)

    # empty expression
    #list(LENGTH parts len)
    #if(${len} EQUAL 0)
     # return()
    #endif()


    # single expreession
  #  message("single expr: ${expr}")
    string(STRIP "${expr}" expr)

    #exression is string
    expr_string_isvalid("${expr}")
    ans(is_string)
    if(is_string)
      #message("isstring")
      expr_string_parse("${expr}")
      return_ans()
    endif()

    expr_integer_isvalid("${expr}")
    ans(is_integer)
    if(is_integer)
      return_ref(expr)
    endif()

    string_char_at( 0 "${expr}" )
    ans(first_char)
    if("${first_char}" STREQUAL "*")
      string_slice("${expr}" 1 -1)
      ans(ref)
      ref_get(${ref})
      ans(val)
      return_ans()
    endif()



    expr_navigate_isvalid("${expr}")
    ans(is_navigation)
    if(is_navigation)
      #message("is navigation ${expr}")
      expr_navigate("${expr}")
      return_ans()
    endif()

    expr_indexer_isvalid("${expr}")
    ans(is_indexer)
    if(is_indexer)
     # message("is_indexer ${expr}")
      expr_indexer("${expr}")
      return_ans()
    endif()

    expr_call_isvalid("${expr}")
    ans(iscall)
    if(iscall)
      expr_call("${expr}")
      return_ans()
    endif()

    expr_function_isvalid("${expr}")
    ans(isfunction)
    if(isfunction)
      expr_function("${expr}")
      return_ans()
    endif()

    if(DEFINED "${expr}")
      return_ref("${expr}")
    endif()


   return()


  endfunction()
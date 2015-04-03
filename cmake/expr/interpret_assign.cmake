

  function(interpret_assign tokens)
    list(REVERSE tokens)
    set(rhs)
    set(lhs)
    set(equals_token)
    foreach(token ${tokens})
      map_tryget("${token}" type)
      ans(type)
      if(equals_token)
        list(APPEND lhs ${token})
      elseif("${type}" STREQUAL "equals")
        set(equals_token ${token})
      else()
        list(APPEND rhs ${token})
      endif()
    endforeach()
    if(NOT rhs)
      return()
    endif()
    if(NOT lhs)
      return()
    endif()
    list(REVERSE rhs)
    list(REVERSE lhs)

    interpret_rvalue("${rhs}")
    ans(rvalue)

    if(NOT rvalue)
      return()
    endif()


    map_tryget("${rvalue}" argument)
    ans(rvalue_argument)

    interpret_lvalue("${lhs}" "${rvalue}")
    ans(lvalue)

    if(NOT lvalue)
      return()
    endif()

    map_tryget("${rvalue}" code)
    ans(rvalue_code)

    map_tryget("${lvalue}" id)
    ans(id)
   
    map_tryget("${lvalue}" code)
    ans(lvalue_code)

    map_tryget("${lvalue}" argument)
    ans(lvalue_argument)

    set(code "${rvalue_code}${lvalue_code}")    
    set(argument "${lvalue_argument}")


    map_new()
    ans(ast)
    map_set(${ast} type assign)
    map_set(${ast} argument "${argument}")
    map_set(${ast} code "${code}")

    return_ref(ast)

  endfunction()



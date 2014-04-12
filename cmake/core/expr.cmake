  # evaluates a oo-cmake expression
  function(expr input)
    return_reset()

    function(expr_single expr )
      string(LENGTH "${expr}" len)
      string_char_at()

      map_format(res "${expr}")
      return_ref(res)
    endfunction()
 



    string_nested_split("${input}" { })
    ans(parts)

    list(LENGTH parts len)
    if(${len} EQUAL 0)
      return()
    endif()
    if("${len}" EQUAL 1)
      expr_single("${parts}")
      return_ans()
    endif()

    message("parts ${parts}")

    set(result)
    foreach(part ${parts})

      expr("${part}")
      ans(res)
      set(result "${result}${res}")
    endforeach()

    return_ref(result)


    map_format(res "${__arg_eval_input}")
    return_ref(res)
  endfunction()
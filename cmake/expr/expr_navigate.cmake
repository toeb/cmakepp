
  function(expr_navigate path)
    string_split_at_last(path nav "${path}" ".")
   # message("expr_nav path: ${path}, nav ${nav}")
    expr("${path}")
    ans(res)
    map_isvalid("${res}" ismap)
    if(NOT ismap)
      return()
    endif()

    map_get(${res} res "${nav}")
    return_ref(res)
  endfunction()

  function(ast_json_eval_value_list ast scope)
    map_get(${ast} children children)
    ref_get(${children} children)
    set(values)
    foreach(child ${children})
      ast_eval(${child} ${scope})
      ans(value)
      list(APPEND values ${value})
    #  message("value ${value}")
    endforeach()

    return_ref(values)
  endfunction()
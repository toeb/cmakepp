

   function(ast_json_eval_key_value_list ast scope)

    map_get(${ast} children children)
    ref_get(${children} children)
    foreach(child ${children})
      ast_eval(${child} ${scope})
    endforeach()

  endfunction()
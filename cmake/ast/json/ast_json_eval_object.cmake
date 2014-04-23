
  function(ast_json_eval_object )#ast scope
    map_new()
    ans(map)
    map_get(${ast} keyvalues children)
    foreach(keyvalue ${keyvalues})
      ast_eval(${keyvalue} ${map})
    endforeach()
    return(${map})
  endfunction()
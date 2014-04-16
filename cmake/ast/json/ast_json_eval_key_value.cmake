
  function(ast_json_eval_key_value ast scope)
    map_get(${ast} children children)
    ref_get(${children} value)
    list_pop_front(key value)
    ast_eval(${key} ${scope})
    ans(key)
    ast_eval(${value} ${scope})
    ans(value)

    #message("keyvalue ${key}:${value}")
    map_set(${scope} ${key} ${value})
  endfunction()
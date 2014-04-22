
  function(ast_json_eval_key_value )#ast scope
    map_get(${ast} value children)
    list_pop_front(key value)
    ast_eval(${key} ${context})
    ans(key)
    ast_eval(${value} ${context})
    ans(value)

    #message("keyvalue ${key}:${value}")
    map_set(${context} ${key} ${value})
  endfunction()

  function(ast_eval_assignment ast scope)
    message("eval assignment")
    map_get(${ast} children)
    ans(children)
    ref_get(${children})
    ans(rvalue)
    list_pop_front(lvalue rvalue)
    ref_print("${lvalue}")
    ref_print("${rvalue}")
    ast_eval(${rvalue} ${scope})
    ans(val)
    message("assigning value ${val} to")

    map_get(${lvalue} types types)
    message("types for lvalue ${types}")

    map_get(${lvalue} identifier data)
    map_set(${scope} "${identifier}" ${val})

  endfunction()
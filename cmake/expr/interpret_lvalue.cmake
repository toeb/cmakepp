


  function(interpret_lvalue tokens argument)
    interpret_scope_lvalue("${tokens}" "${argument}")
    return_ans()
  endfunction()
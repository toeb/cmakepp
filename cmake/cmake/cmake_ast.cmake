
  function(cmake_ast ast)
    ref_isvalid("${ast}")
    ans(isref)
    if(NOT isref)
      cmake_ast_parse("${ast}")
      ans(ast)
    endif()
    return_ref(ast)
  endfunction()




  function(cmake_set_variable ast variable_path value)
    cmake_tokens("${value}")
    ans(value)
    cmake_ast("${ast}")
    ans(ast)

    regex_cmake()
    string(REGEX REPLACE "(${regex_cmake_identifier})\\." "command-\\1." variable_path "${variable_path}")
    string(REGEX REPLACE "([^\\.]+)$" "variable-\\1" variable_path "${variable_path}")

    list_peek_front(value)
    ans(begin_replace)
    list_peek_back(value)
    ans(end_replace)

    assign(begin = "ast.${variable_path}.values_begin")
    assign(end = "ast.${variable_path}.values_end.previous")
    
    token_range_replace("${begin}" "${end}" "${begin_replace}" "${end_replace}")

    cmake_unparse_ast("${ast}")
    return_ans()
  endfunction()

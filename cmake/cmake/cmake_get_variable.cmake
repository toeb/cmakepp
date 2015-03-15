


  function(cmake_get_variable ast variable_path)
    cmake_ast("${ast}")
    ans(ast)

    regex_cmake()
    string(REGEX REPLACE "(${regex_cmake_identifier})\\." "command-\\1." variable_path "${variable_path}")
    string(REGEX REPLACE "([^\\.]+)$" "variable-\\1" variable_path "${variable_path}")

    assign(begin = "ast.${variable_path}.values_begin")
    assign(end = "ast.${variable_path}.values_end")


    cmake_unparse_range("${begin}" "${end}")
    return_ans()
  endfunction()
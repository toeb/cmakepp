
  function(cmake_rename_function ast function_path new_name)
    cmake_ast("${ast}")
    ans(ast)

    regex_cmake()
    string(REGEX REPLACE "(${regex_cmake_identifier})" "command-\\1" function_path "${function_path}")
    assign("ast.${function_path}.name_token.value" = new_name)
    cmake_unparse_ast("${ast}")
    return_ans()
  endfunction()
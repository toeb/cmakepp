  function(cmake_extract_function ast function_path)
    cmake_ast("${ast}")
    ans(ast)

    regex_cmake()
    string(REGEX REPLACE "(${regex_cmake_identifier})" "command-\\1" function_path "${function_path}")
    assign(function = "ast.${function_path}")
      
    assign(endfunction = function.invocation_nesting_end)

    token_find_next_type("${endfunction}" "nesting")
    ans(nesting)
    map_tryget(${nesting} end)
    ans(end)
    map_tryget(${end} next)
    ans(end)

    cmake_unparse_range("${function}" "${end}")
    return_ans()
  endfunction()

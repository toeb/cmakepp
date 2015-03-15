
  function(cmake_unparse_ast ast)
    cmake_ast("${ast}")
    ans(ast)
    assign(start = ast.tokens[0])
    assign(end = ast.tokens[$])
    cmake_unparse_range("${start}" "${end}")
    return_ans()
  endfunction()


function(interpret_expression tokens)

  interpret_assign("${tokens}")
  ans(ast)
  if(ast)

    return(${ast})
  endif()

  interpret_rvalue("${tokens}")
  ans(ast)
  if(ast)
    return(${ast})
  endif()
  return_ans()
endfunction()
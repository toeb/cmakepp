
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



  throw("could not intepret expression" --function interpret_expression)
endfunction()
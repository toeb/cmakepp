

function(interpret_rvalue tokens)
  interpret_paren("${tokens}")
  ans(ast)
  if(ast)
    returN(${ast})
  endif()

  interpret_ellipsis("${tokens}")
  ans(ast)
  if(ast)
    return(${ast})
  endif()

  interpret_literals("${tokens}")
  ans(ast)
  if(ast)
    return(${ast})
  endif()

  interpret_call("${tokens}")
  ans(ast)
  if(ast)
    return(${ast})
  endif()

  interpret_list("${tokens}")
  ans(ast)
  if(ast)
    return(${ast})
  endif()

  ## needs to come before navigation rvalue because $ needs to bind
  ## stronger
  interpret_scope_rvalue("${tokens}")
  ans(ast)
  if(ast)
    return(${ast})
  endif()

  interpret_navigation_rvalue("${tokens}")
  ans(ast)
  if(ast)

    return(${ast})
  endif()



  interpret_object("${tokens}")
  ans(ast)
  if(ast)
    return(${ast})
  endif()

  throw("could not interpret rvalue" --function interpret_rvalue )
endfunction()





function(interpret_rvalue tokens)
  
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

  interpret_bracket("${tokens}")
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

  return()
endfunction()




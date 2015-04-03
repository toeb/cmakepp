function(interpret_literals tokens)
  set(code)
  set(literals)
  set(argument)
  foreach(token ${tokens})
    interpret_literal("${token}")
    ans(literal)
    if(NOT literal)
      ## something other than a literal 
      ## causes this not to be a literal
      return()
    endif()

    #print_vars(literal.type literal.argument literal.code)

    list(APPEND literals "${literal}")

    map_tryget("${literal}" code)
    ans(literal_code)
    
    set(code "${code}${literal_code}")

    map_tryget("${literal}" argument)
    ans(literal_argument)
    set(argument "${argument}${literal_argument}")
  endforeach()
 #   print_vars(argument )

  ## single literal is retunred directly
  ## 
  list(LENGTH literals length)
  if("${length}" LESS 2)
    return_ref(literals)
  endif()

  ## else a string literal is uses
  map_new()
  ans(ast)
  map_set("${ast}" type composite_string)
  map_set("${ast}" literals ${literals})
  map_set("${ast}" code "${code}")
  map_set("${ast}" argument "${argument}")
  map_set("${ast}" static true)
  return(${ast})
endfunction()

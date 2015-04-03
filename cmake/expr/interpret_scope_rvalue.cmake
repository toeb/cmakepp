
function(interpret_scope_rvalue tokens)
  list(LENGTH tokens count)
  if(NOT ${count} EQUAL 2)
    return()
  endif()

  list(GET tokens 0 dollar)
  list(GET tokens 1 identifier_token)


  map_tryget("${dollar}" type)
  ans(type)
  if(NOT "${type}" STREQUAL "dollar")
    return()
  endif()

  map_tryget("${identifier_token}" type)
  ans(type)

  set(identifier)
  if("${type}" MATCHES "^(quoted)|(unquoted)$")
    interpret_literal("${identifier_token}")
    ans(identifier)
  elseif("${type}" STREQUAL "paren")
    interpret_rvalue("${identifier_token}")
    ans(identifier)
  endif()

  if(NOT identifier)
    return()
  endif()

  map_tryget("${identifier}" code)
  ans(identifier_code)
  map_tryget("${identifier}" argument)
  ans(identifier_argument)

  #print_vars(identifier.code identifier.argument)


  set(code "${identifier_code}")
  set(argument "\${${identifier_argument}}")

  
  map_new()
  ans(ast)
  map_set("${ast}" type "scope_rvalue")
  map_set("${ast}" argument "${argument}")
  map_set("${ast}" code "${code}")

  #print_vars(ast)

  return(${ast})

endfunction()
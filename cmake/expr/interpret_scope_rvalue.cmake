
function(interpret_scope_rvalue tokens)
  #print_vars(tokens)
  list(LENGTH tokens count)
  if(NOT ${count} EQUAL 2)
    throw("expected 2 tokens (got {count}) " --function interpret_scope_rvalue)    
  endif()

  list(GET tokens 0 dollar)
  list(GET tokens 1 identifier_token)


  map_tryget("${dollar}" type)
  ans(type)
  if(NOT "${type}" STREQUAL "dollar")
    throw("expected a `$` as first token " --function interpret_scope_rvalue)
  endif()


  if(NOT identifier_token)
    throw("could find identifier" --function interpret_scope_rvalue)
  endif()


  map_tryget("${identifier_token}" type)
  ans(type)

  set(identifier)
  if("${type}" MATCHES "^(quoted)|(unquoted)$")
    interpret_literal("${identifier_token}")
    ans(identifier)
  elseif("${type}" STREQUAL "paren")
    interpret_paren("${identifier_token}" )
    ans(identifier)
  elseif("${type}" STREQUAL "bracket")
    interpret_bracket("${identifier_token}")
    ans(identifier)
  
  endif()
  if(NOT identifier)
    throw("could interpret identifier" --function interpret_scope_rvalue)
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
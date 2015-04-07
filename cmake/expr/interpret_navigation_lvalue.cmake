function(interpret_navigation_lvalue tokens assign_to)
  list(LENGTH tokens token_count)
  if(${token_count} LESS 2)
    throw("expected at least two tokens (got {token_count})" --function interpret_navigation_rvalue)
  endif()

  list_pop_back(tokens)
  ans(rhs_token)

  if(NOT tokens)
    throw("expected at least two tokens (got {token_count})" --function interpret_navigation_rvalue)
  endif()

  map_tryget("${rhs_token}" type)
  ans(type)

  if("${type}" STREQUAL "bracket")
    ## interpret range or interpret bracket
    interpret_list("${rhs_token}")
    ans(rhs)
  else()
    list_pop_back(tokens)
    ans(dot)
    map_tryget("${dot}" type)
    ans(type)
    if(NOT "${type}" STREQUAL "dot")
      throw("expected second to last token to be a `.`" --function interpret_navigation_rvalue)
    endif()  
    
    if(NOT tokens)
      throw("no lvalue tokens" --function interpret_navigation_rvalue)
    endif()

    interpret_literal("${rhs_token}")
    ans(rhs)
  endif()

  interpret_rvalue("${tokens}")
  ans(lhs)

  #print_vars(rhs.type rhs.argument rhs.code lhs.type lhs.argument lhs.code --plain)

  map_tryget("${rhs}" code)
  ans(rhs_code)
  map_tryget("${rhs}"  argument)
  ans(rhs_argument)
  map_tryget("${lhs}" code)
  ans(lhs_code)

  map_tryget("${lhs}"  argument)
  ans(lhs_argument)

  map_tryget(${assign_to} argument)
  ans(assign_to_argument)

  map_tryget(${assign_to} code)
  ans(assign_to_code)


  print_vars(lhs_argument rhs_argument assign_to)
  set(code 
"${lhs_code}${rhs_code}
  is_address(\"${lhs_argument}\")
  ans(is_address)
  if(is_address)
    map_set(\"${lhs_argument}\" \"${rhs_argument}\" ${assign_to_argument})
  endif()



")
  set(argument "${assign_to_argument}" )


  map_new()
  ans(ast)
  map_set("${ast}" type "navigation_lvalue")
  map_set("${ast}" code "${code}")
  map_set("${ast}" argument "${argument}")

  return_ref(ast)
endfunction()
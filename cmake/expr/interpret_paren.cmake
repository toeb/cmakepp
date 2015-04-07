

function(interpret_paren paren_token)
  list(LENGTH paren_token count)
  if(NOT "${count}" EQUAL 1)
    throw("expected single paren nesting token got ${count} tokens instread")
  endif()
  map_tryget("${paren_token}" type)
  ans(type)
  if(NOT "${type}" STREQUAL "paren")
    throw("expected paren nesting token got '${type}' type token instead")
  endif()

  map_tryget("${paren_token}" tokens)
  ans(tokens) 

  interpret_expression("${tokens}")
  rethrow() ## rethrow if inner is invalid
  ans(inner_expression)

  map_tryget("${inner_expression}" ref)
  ans(ref)
  
  map_tryget("${inner_expression}" value)
  ans(value)

  map_tryget("${inner_expression}" static)
  ans(static)

  map_tryget("${inner_expression}" value_type)
  ans(value_type)
  
  ast_new(
    "${paren_token}"
    "paren"
    "${value_type}"
    "${ref}"
    "${code}"
    "${value}" #value
    "${static}" # static/const
    "${inner_expression}" # children
    )
  ans(ast)

  return_ref(ast)

endfunction()



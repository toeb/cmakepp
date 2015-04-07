

function(interpret_list list_token)
  list(LENGTH list_token count)
  if(NOT "${count}" EQUAL 1)
    throw("expected single token, got ${count}" --function interpret_list)
  endif()


  map_tryget("${list_token}" type)
  ans(type)
  if(NOT "${type}" STREQUAL "bracket")
    throw("expected a bracket token, got ${type}")
  endif()

  map_tryget("${list_token}" tokens)
  ans(tokens)

  interpret_elements("${tokens}" "comma" "interpret_expression")
  ans(elements)


  set(value)
  set(static true)
  foreach(element ${elements})
    map_tryget("${element}" value)
    ans(element_value)
    set(value "${value};${element_value}")
    map_tryget("${element}" static)
    ans(is_static)
    if(NOT is_static)
      set(static false)
    endif()
  endforeach()

  ## remove prepending semicolon
  if(elements)
    string(SUBSTRING "${value}" 1 -1 value)
  endif()
  
  next_id()
  ans(ref)
  set(code "set(${ref} \"${value}\")\n")

## expression_type value_type value ref code is_static)
   ast_new(
    "${list_token}"
    list   # expr type
    list   # value type
    "${ref}"  # ref
    "${code}" # code
    "${value}"
    "${static}"
    "${elements}"

    )
  ans(ast)
  return_ref(ast)
endfunction()

## `(<command invocation token> <values: <any...>>)-><void>`
##
## replaces the arguments for the specified invocation by the
## specified values
function(cmake_invocation_set_arguments invocation)
  cmake_invocation_get_arguments_range("${invocation}")
  ans_extract(begin end)

  cmake_arguments_quote_if_necessary(${ARGN})
  ans(arguments)
  list(LENGTH ARGN count)
  string(LENGTH "${ARGN}" len)
  

  if(${len} LESS 70 OR ${count} LESS 2)
    string_combine(" " ${arguments})
    ans(argument_string)
  else()
    map_tryget(${begin} column)
    ans(column)
    string_repeat(" " ${column})
    ans(last_indentation)
    math(EXPR column "${column} + 2")
    string_repeat(" " ${column})
    ans(indentation)
    string_combine("\n${indentation}" ${arguments})
    ans(argument_string)
    set(argument_string "\n${indentation}${argument_string}\n${last_indentation}")
  endif()

  cmake_tokens("${argument_string}")
  ans(argument_tokens)
  list_peek_front(argument_tokens)
  ans(replace_first)
  list_peek_back(argument_tokens)
  ans(replace_last)

  token_range_replace("${begin}" "${end}" "${replace_first}" "${replace_last}")
  return()
endfunction()
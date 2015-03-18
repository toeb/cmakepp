## `(<start:<cmake code>|<token>> <identifier:<regex>> [<limit:<int>>])-><command invocation...>`
##
## matches all command invocations in the specified code
## and returns them  limit is the maximum number of matches returned
function(cmake_invocation_find_all range identifier)
  cmake_tokens("${range}")
  ans(range)
  list_peek_front(range)
  ans(begin)
  list_peek_back(range)
  ans(end)

  cmake_token_range_find_invocations("${start};${end}" "${identifier}"  ${ARGN})
  return_ans()
endfunction()
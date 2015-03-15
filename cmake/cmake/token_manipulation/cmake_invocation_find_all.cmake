## `(<start:<cmake code>|<token>> <identifier:<regex>> [<limit:<int>>])-><command invocation...>`
##
## matches all command invocations in the specified code
## and returns them  limit is the maximum number of matches returned
function(cmake_invocation_find_all start identifier)
  cmake_tokens("${start}")
  ans_extract(start)
  set(end)
  cmake_token_range_find_invocations("${identifier}" "${start}" "${end}" ${ARGN})
  return_ans()
endfunction()
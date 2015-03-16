## `(<start:<cmake token>> <end:<cmake token>> <code:<cmake code>|<cmake token>...> )-><void>`
##
## replaces the the specified range with the specified code or tokens
function(cmake_token_range_replace range code)
  cmake_tokens("${code}")
  ans(tokens)
  list_peek_front(tokens)
  ans(replace_start)
  list_peek_back(tokens)
  ans(replace_end)
  cmake_token_range_replace_range("${range}" "${replace_start};${replace_end}")
  return_ans()
endfunction()
## `(<command invocation token>)-><string>`
##
## returns the arguments verbatim as specified in original source
function(cmake_invocation_get_arguments invocation)
  cmake_invocation_get_arguments_range("${invocation}")
  ans_extract(begin end)
  cmake_token_range_serialize("${begin};${end}")
  return_ans()
endfunction()

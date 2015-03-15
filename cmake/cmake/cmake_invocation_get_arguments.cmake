## `(<command invocation token>)-><string>`
##
## returns the arguments verbatim as specified in original source
function(cmake_invocation_get_arguments invocation)
  cmake_invocation_get_arguments_range("${invocation}")
  ans_extract(begin end)
  cmake_unparse_range(${begin} ${end})
  return_ans()
endfunction()

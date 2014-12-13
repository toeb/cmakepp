
function(string_take_commandline_arg __string_take_commandline_arg_string_ref)
  string_take_regex(${__string_take_commandline_arg_string_ref} " *(\"([^\"]|\\\")*\"|[^ ])")
  ans(__string_take_commandline_arg_result)
  string_take_whitespace(__string_take_commandline_arg_result)
  set("${__string_take_commandline_arg_string_ref}" "${${__string_take_commandline_arg_string_ref}}" PARENT_SCOPE)
  return_ref(__string_take_commandline_arg_result)
endfunction()

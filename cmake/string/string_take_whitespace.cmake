

function(string_take_whitespace str_ref)
  string_take_regex("${str_ref}" "[ ]+")
  ans(res)
  set("${str_ref}" "${${str_ref}}" PARENT_SCOPE)
  return_ref(res)
endfunction()

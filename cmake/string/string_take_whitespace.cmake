

function(string_take_whitespace __string_take_whitespace_string_ref)
  string_take_regex("${__string_take_whitespace_string_ref}" "[ ]+")
  ans(__string_take_whitespace_res)
  set("${__string_take_whitespace_string_ref}" "${${__string_take_whitespace_string_ref}}" PARENT_SCOPE)
  return_ref(__string_take_whitespace_res)
endfunction()


## faster
macro(string_take_whitespace __str_ref)
  if("${${__str_ref}}" MATCHES "^([ ]+)(.*)")
    set(__ans "${CMAKE_MATCH_1}")
    set(${__str_ref} "${CMAKE_MATCH_2}")
  else()
    set(__ans)
  endif()
endmacro()



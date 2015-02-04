## if the beginning of the str_name is a delimited string
## the undelimited string is returned  and removed from str_name
## you can specify the delimiter (default is doublequote "")
## you can also specify begin and end delimiter 
## the delimiters may only be one char 
## the delimiters are removed from the result string
## escaped delimiters are unescaped
function(string_take_delimited __string_take_delimited_string_ref )
  regex_delimited_string(${ARGN})
  ans(__string_take_delimited_regex)
  string_take_regex(${__string_take_delimited_string_ref} "${__string_take_delimited_regex}")
  ans(__string_take_delimited_match)
  if(NOT __string_take_delimited_match)
    return()
  endif()
  set("${__string_take_delimited_string_ref}" "${${__string_take_delimited_string_ref}}" PARENT_SCOPE)

  # removes the delimiters
  string_slice("${__string_take_delimited_match}" 1 -2)
  ans(res)
  # unescape string
  string(REPLACE "\\${delimiter_end}" "${delimiter_end}" res "${res}")
  return_ref(res) 
endfunction()


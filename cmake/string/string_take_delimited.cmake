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

## faster version
function(string_take_delimited __str_ref )
  set(input "${${__str_ref}}")

  regex_delimited_string(${ARGN})
  ans(regex)
  if("${input}" MATCHES "^${regex}")
    string(LENGTH "${CMAKE_MATCH_0}" len)
    if(len)
      string(SUBSTRING "${input}" ${len} -1 input )
    endif()
    string(REPLACE "\\${delimiter_end}" "${delimiter_end}" res "${CMAKE_MATCH_1}")
    set("${__str_ref}" "${input}" PARENT_SCOPE)
    set(__ans "${res}" PARENT_SCOPE)
  else()
    set(__ans PARENT_SCOPE)
  endif()

endfunction()


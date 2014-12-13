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


## returns the regex for a delimited string 
## allows escaping delimiter with '\' backslash
function(regex_delimited_string)
  set(delimiters ${ARGN})


  if("${delimiters}_" STREQUAL "_")
    set(delimiters \")
  endif()



  list_pop_front(delimiters)
  ans(delimiter_begin)


  if("${delimiter_begin}" MATCHES ..)
    string(REGEX REPLACE "(.)(.)" "\\2" delimiter_end "${delimiter_begin}")
    string(REGEX REPLACE "(.)(.)" "\\1" delimiter_begin "${delimiter_begin}")
  else()
    list_pop_front(delimiters)
    ans(delimiter_end)
  endif()

  
  if("${delimiter_end}_" STREQUAL "_")
    set(delimiter_end "${delimiter_begin}")
  endif()
  #set(regex "${delimiter_begin}(([^${delimiter_end}])*)${delimiter_end}")
  set(delimiter_end "${delimiter_end}" PARENT_SCOPE)
  #set(regex "${delimiter_begin}(([^${delimiter_end}\\]|(\\[${delimiter_end}])|\\\\)*)${delimiter_end}")
  regex_escaped_string("${delimiter_begin}" "${delimiter_end}")
  ans(regex)
  return_ref(regex)
endfunction()


function(regex_escaped_string delimiter_begin delimiter_end)

  set(regex "${delimiter_begin}(([^${delimiter_end}\\]|(\\${delimiter_end})|\\\\)*)${delimiter_end}")
  return_ref(regex)
endfunction()
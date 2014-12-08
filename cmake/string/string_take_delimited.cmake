## if the beginning of the str_name is a delimited string
## the undelimited string is returned  and removed from str_name
function(string_take_delimited str_name )
  set(delimiter ${ARGN})
  if("${delimiter}_" STREQUAL "_")
    set(delimiter \")
  endif()
  set(regex "${delimiter}([^${delimiter}]*)${delimiter}")
  string_take_regex(${str_name} "${regex}")

  ans(match)
  if(NOT match)
    return()
  endif()
  set("${str_name}" "${${str_name}}" PARENT_SCOPE)
  string_slice("${match}" 1 -2)
  ans(res)

  return_ref(res)    
endfunction()

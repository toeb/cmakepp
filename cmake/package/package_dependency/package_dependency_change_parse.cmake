## `(<change action>)->[ <admissable uri>, <action>]`
##
## parses a change action `<change action> ::= <admissable uri> [" " <action>]`
## `<action> ::= "add"|"remove"|"optional"|<dependency constraint>`
## the default action is `add`
function(package_dependency_change_parse)
  set(action ${ARGN})
  string_take_regex(action "[^ ]+")
  ans(admissable_uri)
  if("${admissable_uri}_" STREQUAL "_")
    return()
  endif()
  string_take_whitespace(action)
  data("${action}")
  ans(action)

  if("${action}_" STREQUAL "_")
    set(action add)
  endif()

  is_address(${action})
  ans(isref)  
  if(isref)
    set(action add ${action})
  elseif("${action}" MATCHES "^((add)|(remove)|(optional)|(conflict))$")
    set(action ${CMAKE_MATCH_1})
  else()
    message(FATAL_ERROR "invalid change: ${action}")
  endif()

  set(result ${admissable_uri} ${action})
  return_ref(result)
endfunction()

## `(<identifier:<regex>> <start:<token>> <end:<token>> [<limmit>:<uint>])-><command invocation...>`
##
## returns all invocations which match the specified identifer regex
## only look between start and end
function(token_find_invocations identifier start end )
  set(args ${ARGN})
  
  set(limit ${args})
  set(current ${start})
  set(result)
  set(count 0)
  while(current)
    if(limit AND NOT "${count}" LESS "${limit}")
      break()
    endif()
    if("${current}_" STREQUAL "${end}_")
      break()
    endif()

    map_tryget(${current} type)
    ans(type)
    if("${type}" STREQUAL "command_invocation")
      map_tryget(${current} value)
      ans(current_identifier)
      if("${current_identifier}" MATCHES "^${identifier}$")
        list(APPEND result ${current})
        math(EXPR count "${count} + 1")
      endif()
    endif()

    map_tryget(${current} next)
    ans(current)
  endwhile()
  return_ref(result)  
endfunction()